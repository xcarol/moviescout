import { env } from '$env/dynamic/private';
import { TMDB_CACHE_TTL_MS, TMDB_TIMEOUT_MS } from '$lib/constants/app';
import { TMDB_API_BASE_URL } from '$lib/constants/urls';
import type { SupportedLocale } from '$lib/i18n';
import type {
	CollectionDetails,
	EpisodeDetails,
	EpisodeSummary,
	ExternalLinks,
	MediaType,
	PersonCredit,
	PersonDetails,
	PersonSummary,
	SeasonDetails,
	SeasonSummary,
	TitleDetails,
	TitleSummary,
	TmdbVideo,
	WatchProviderItem,
	WatchProviders
} from '$lib/types/tmdb';
import { TtlLruCache } from './cache';

const tmdbCache = new TtlLruCache<unknown>({
	maxEntries: 600,
	defaultTtlMs: TMDB_CACHE_TTL_MS
});

export class TmdbConfigError extends Error {
	constructor(message = 'TMDB_API_RAT environment variable is not configured') {
		super(message);
		this.name = 'TmdbConfigError';
	}
}

export class TmdbUpstreamError extends Error {
	readonly status: number;

	constructor(status: number, path: string) {
		super(`TMDB API request failed (${status}) for ${path}`);
		this.name = 'TmdbUpstreamError';
		this.status = status;
	}
}

export function parseTmdbId(rawParam: string): number | null {
	const match = /^(\d+)(?:-.*)?$/.exec(rawParam.trim());
	if (!match) return null;
	const parsed = Number.parseInt(match[1], 10);
	return Number.isSafeInteger(parsed) && parsed > 0 ? parsed : null;
}

export function parseSeasonNumber(rawParam: string): number | null {
	if (!/^\d+$/.test(rawParam.trim())) return null;
	const parsed = Number.parseInt(rawParam.trim(), 10);
	return Number.isSafeInteger(parsed) && parsed >= 0 ? parsed : null;
}

export function parseEpisodeNumber(rawParam: string): number | null {
	if (!/^\d+$/.test(rawParam.trim())) return null;
	const parsed = Number.parseInt(rawParam.trim(), 10);
	return Number.isSafeInteger(parsed) && parsed > 0 ? parsed : null;
}

function toTmdbLanguage(locale: SupportedLocale): string {
	// TMDB uses es-MX rather than es-419 for Latin American Spanish.
	return locale === 'es-419' ? 'es-MX' : locale;
}

function buildIncludeLanguages(locale: SupportedLocale): string {
	const tmdbLang = toTmdbLanguage(locale);
	const baseLang = locale.split('-')[0];
	return Array.from(new Set([tmdbLang, baseLang, 'null', 'en'])).join(',');
}

async function fetchTmdbJson<T>(path: string, params: Record<string, string> = {}): Promise<T | null> {
	const token = env.TMDB_API_RAT?.trim();
	if (!token) {
		throw new TmdbConfigError();
	}

	const url = new URL(`${TMDB_API_BASE_URL}${path}`);
	for (const [key, value] of Object.entries(params)) {
		if (value) url.searchParams.set(key, value);
	}

	const response = await fetch(url, {
		headers: {
			Authorization: `Bearer ${token}`,
			Accept: 'application/json'
		},
		signal: AbortSignal.timeout(TMDB_TIMEOUT_MS)
	});

	if (response.status === 404) return null;
	if (!response.ok) {
		throw new TmdbUpstreamError(response.status, path);
	}

	return (await response.json()) as T;
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type RawRecord = Record<string, any>;

function extractTopImages(items: unknown, limit = 10): string[] {
	if (!Array.isArray(items)) return [];
	return [...items]
		.filter((item): item is RawRecord => Boolean(item && typeof item === 'object' && item.file_path))
		.sort((a, b) => Number(b.vote_average ?? 0) - Number(a.vote_average ?? 0))
		.slice(0, limit)
		.map((item) => String(item.file_path));
}

function extractTopYoutubeVideos(items: unknown, limit = 5): TmdbVideo[] {
	if (!Array.isArray(items)) return [];
	return [...items]
		.filter(
			(item): item is RawRecord =>
				Boolean(
					item &&
						typeof item === 'object' &&
						item.key &&
						String(item.site ?? '').toLowerCase() === 'youtube'
				)
		)
		.sort((a, b) => {
			const aOfficial = a.official === true ? 1 : 0;
			const bOfficial = b.official === true ? 1 : 0;
			if (aOfficial !== bOfficial) return bOfficial - aOfficial;

			const aTrailer = a.type === 'Trailer' ? 1 : 0;
			const bTrailer = b.type === 'Trailer' ? 1 : 0;
			return bTrailer - aTrailer;
		})
		.slice(0, limit)
		.map((v) => ({
			key: String(v.key),
			site: String(v.site ?? 'YouTube'),
			name: String(v.name ?? ''),
			iso6391: v.iso_639_1 ? String(v.iso_639_1) : null,
			official: Boolean(v.official),
			type: String(v.type ?? '')
		}));
}

function parsePersonSummaryList(items: unknown, roleType: 'cast' | 'crew'): PersonSummary[] {
	if (!Array.isArray(items)) return [];
	const people: PersonSummary[] = [];
	const indexById = new Map<number, number>();

	for (const raw of items) {
		if (!raw || typeof raw !== 'object') continue;
		const id = Number(raw.id ?? 0);
		if (!id) continue;

		let role = '';
		if (roleType === 'cast') {
			if (Array.isArray(raw.roles)) {
				role = raw.roles
					.map((r: RawRecord) => String(r?.character ?? ''))
					.filter(Boolean)
					.join(', ');
			} else {
				role = String(raw.character ?? '');
			}
		} else {
			if (Array.isArray(raw.jobs)) {
				role = raw.jobs
					.map((j: RawRecord) => String(j?.job ?? ''))
					.filter(Boolean)
					.join(', ');
			} else {
				role = String(raw.job ?? '');
			}
		}

		const existingIndex = indexById.get(id);
		if (existingIndex !== undefined) {
			const existing = people[existingIndex];
			if (role && !existing.role.includes(role)) {
				existing.role = existing.role ? `${existing.role}, ${role}` : role;
			}
			continue;
		}

		indexById.set(id, people.length);
		people.push({
			id,
			name: String(raw.name ?? ''),
			profilePath: raw.profile_path ? String(raw.profile_path) : null,
			role,
			department: raw.known_for_department
				? String(raw.known_for_department)
				: raw.department
					? String(raw.department)
					: undefined,
			order: typeof raw.order === 'number' ? raw.order : undefined
		});
	}

	return people;
}

function parseExternalLinks(rawExternalIds: RawRecord | undefined, homepage?: string): ExternalLinks {
	return {
		imdbId: rawExternalIds?.imdb_id ? String(rawExternalIds.imdb_id) : undefined,
		wikidataId: rawExternalIds?.wikidata_id ? String(rawExternalIds.wikidata_id) : undefined,
		facebookId: rawExternalIds?.facebook_id ? String(rawExternalIds.facebook_id) : undefined,
		instagramId: rawExternalIds?.instagram_id ? String(rawExternalIds.instagram_id) : undefined,
		twitterId: rawExternalIds?.twitter_id ? String(rawExternalIds.twitter_id) : undefined,
		tiktokId: rawExternalIds?.tiktok_id ? String(rawExternalIds.tiktok_id) : undefined,
		youtubeId: rawExternalIds?.youtube_id ? String(rawExternalIds.youtube_id) : undefined,
		homepage: homepage || undefined
	};
}

function mapProviderItems(items: unknown): WatchProviderItem[] {
	if (!Array.isArray(items)) return [];
	return items
		.filter((item): item is RawRecord => Boolean(item && typeof item === 'object' && item.provider_id))
		.map((item) => ({
			providerId: Number(item.provider_id),
			providerName: String(item.provider_name ?? ''),
			logoPath: item.logo_path ? String(item.logo_path) : null,
			displayPriority: Number(item.display_priority ?? 999)
		}))
		.sort((a, b) => a.displayPriority - b.displayPriority);
}

function extractProviders(rawProviders: RawRecord | undefined, region: string): WatchProviders {
	const regionData = rawProviders?.results?.[region] as RawRecord | undefined;
	if (!regionData) {
		return { flatrate: [], free: [], ads: [], rent: [], buy: [] };
	}

	return {
		link: regionData.link ? String(regionData.link) : undefined,
		flatrate: mapProviderItems(regionData.flatrate),
		free: mapProviderItems(regionData.free),
		ads: mapProviderItems(regionData.ads),
		rent: mapProviderItems(regionData.rent),
		buy: mapProviderItems(regionData.buy)
	};
}

function extractCertification(
	details: RawRecord,
	mediaType: MediaType,
	region: string
): string | null {
	if (mediaType === 'movie') {
		const results = details.release_dates?.results;
		if (!Array.isArray(results)) return null;
		const match = results.find((r: RawRecord) => r?.iso_3166_1 === region);
		const dates = match?.release_dates;
		if (!Array.isArray(dates)) return null;
		const withCert = dates.find(
			(d: RawRecord) => typeof d?.certification === 'string' && d.certification.trim().length > 0
		);
		return withCert ? String(withCert.certification).trim() : null;
	}

	const results = details.content_ratings?.results;
	if (!Array.isArray(results)) return null;
	const match = results.find((r: RawRecord) => r?.iso_3166_1 === region);
	const rating = match?.rating ? String(match.rating).trim() : '';
	return rating || null;
}

function applyTranslationFallback(
	target: { title: string; overview: string },
	translations: unknown,
	locale: SupportedLocale,
	region: string,
	mediaType: MediaType | 'collection'
): void {
	if (!Array.isArray(translations)) return;
	const fallbacks = Array.from(
		new Set([locale.split('-')[0].toLowerCase(), region.toLowerCase(), 'en'])
	);

	for (const lang of fallbacks) {
		if (target.overview && target.title) break;
		const match = translations.find(
			(item: RawRecord) => String(item?.iso_639_1 ?? '').toLowerCase() === lang
		);
		const data = match?.data as RawRecord | undefined;
		if (!data) continue;

		if (!target.overview && typeof data.overview === 'string' && data.overview.trim()) {
			target.overview = data.overview.trim();
		}

		const candidateTitle =
			mediaType === 'movie'
				? data.title
				: mediaType === 'tv'
					? data.name
					: data.name || data.title;
		if (!target.title && typeof candidateTitle === 'string' && candidateTitle.trim()) {
			target.title = candidateTitle.trim();
		}
	}
}

function toTitleSummary(raw: RawRecord, forcedMediaType?: MediaType): TitleSummary {
	const mediaType: MediaType =
		forcedMediaType ?? (raw.media_type === 'tv' || (!raw.title && raw.name) ? 'tv' : 'movie');
	return {
		id: Number(raw.id),
		mediaType,
		title: String(raw.title ?? raw.name ?? ''),
		originalTitle: String(raw.original_title ?? raw.original_name ?? ''),
		posterPath: raw.poster_path ? String(raw.poster_path) : null,
		backdropPath: raw.backdrop_path ? String(raw.backdrop_path) : null,
		releaseDate: String(raw.release_date ?? raw.first_air_date ?? ''),
		voteAverage: Number(raw.vote_average ?? 0),
		voteCount: Number(raw.vote_count ?? 0),
		overview: String(raw.overview ?? ''),
		genreIds: Array.isArray(raw.genre_ids)
			? raw.genre_ids.map((id: unknown) => Number(id)).filter((id: number) => !Number.isNaN(id))
			: []
	};
}

export async function getTitleDetails(
	mediaType: MediaType,
	id: number,
	locale: SupportedLocale,
	region: string
): Promise<TitleDetails | null> {
	const cacheKey = `title:${mediaType}:${id}:${locale}:${region}`;
	return tmdbCache.getOrFetch(cacheKey, async () => {
		const tmdbLang = toTmdbLanguage(locale);
		const includeLangs = buildIncludeLanguages(locale);
		const creditsField = mediaType === 'movie' ? 'credits' : 'aggregate_credits';

		const raw = await fetchTmdbJson<RawRecord>(`/${mediaType}/${id}`, {
			append_to_response: `translations,keywords,external_ids,watch/providers,recommendations,images,videos,${creditsField},release_dates,content_ratings`,
			language: tmdbLang,
			include_image_language: includeLangs,
			include_video_language: includeLangs
		});

		if (!raw) return null;

		const localizedText = {
			title: String(mediaType === 'movie' ? (raw.title ?? '') : (raw.name ?? '')),
			overview: String(raw.overview ?? '')
		};

		applyTranslationFallback(
			localizedText,
			raw.translations?.translations,
			locale,
			region,
			mediaType
		);

		const creditsBlock = raw[creditsField] ?? raw.credits ?? {};
		const genres: Array<{ id: number; name: string }> = Array.isArray(raw.genres)
			? raw.genres.map((g: RawRecord) => ({ id: Number(g.id), name: String(g.name ?? '') }))
			: [];

		const seasons: SeasonSummary[] = Array.isArray(raw.seasons)
			? raw.seasons.map((s: RawRecord) => ({
					id: Number(s.id ?? 0),
					seasonNumber: Number(s.season_number ?? 0),
					name: String(s.name ?? ''),
					overview: String(s.overview ?? ''),
					posterPath: s.poster_path ? String(s.poster_path) : null,
					airDate: String(s.air_date ?? ''),
					episodeCount: Number(s.episode_count ?? 0),
					voteAverage: Number(s.vote_average ?? 0)
				}))
			: [];

		const recommendations: TitleSummary[] = Array.isArray(raw.recommendations?.results)
			? raw.recommendations.results.map((r: RawRecord) => toTitleSummary(r, mediaType))
			: [];

		const belongsToCollection = raw.belongs_to_collection
			? {
					id: Number(raw.belongs_to_collection.id),
					name: String(raw.belongs_to_collection.name ?? ''),
					posterPath: raw.belongs_to_collection.poster_path
						? String(raw.belongs_to_collection.poster_path)
						: null,
					backdropPath: raw.belongs_to_collection.backdrop_path
						? String(raw.belongs_to_collection.backdrop_path)
						: null
				}
			: null;

		const imdbId = raw.external_ids?.imdb_id ? String(raw.external_ids.imdb_id) : null;
		const homepage = raw.homepage ? String(raw.homepage) : undefined;
		const episodeRunTime = Array.isArray(raw.episode_run_time)
			? raw.episode_run_time.map((n: unknown) => Number(n)).filter((n: number) => n > 0)
			: [];

		return {
			id: Number(raw.id),
			mediaType,
			title: localizedText.title,
			originalTitle: String(raw.original_title ?? raw.original_name ?? ''),
			originalLanguage: String(raw.original_language ?? ''),
			tagline: String(raw.tagline ?? ''),
			overview: localizedText.overview,
			status: String(raw.status ?? ''),
			posterPath: raw.poster_path ? String(raw.poster_path) : null,
			backdropPath: raw.backdrop_path ? String(raw.backdrop_path) : null,
			images: extractTopImages(raw.images?.backdrops, 10),
			videos: extractTopYoutubeVideos(raw.videos?.results, 5),
			releaseDate: String(raw.release_date ?? raw.first_air_date ?? ''),
			lastAirDate: raw.last_air_date ? String(raw.last_air_date) : undefined,
			runtime: typeof raw.runtime === 'number' && raw.runtime > 0 ? raw.runtime : null,
			episodeRunTime,
			numberOfSeasons:
				typeof raw.number_of_seasons === 'number' ? raw.number_of_seasons : undefined,
			numberOfEpisodes:
				typeof raw.number_of_episodes === 'number' ? raw.number_of_episodes : undefined,
			voteAverage: Number(raw.vote_average ?? 0),
			voteCount: Number(raw.vote_count ?? 0),
			genreIds: genres.map((g) => g.id),
			genres,
			originCountry: Array.isArray(raw.origin_country)
				? raw.origin_country.map((c: unknown) => String(c))
				: Array.isArray(raw.production_countries)
					? raw.production_countries.map((c: RawRecord) => String(c.iso_3166_1 ?? '')).filter(Boolean)
					: [],
			spokenLanguages: Array.isArray(raw.spoken_languages)
				? raw.spoken_languages.map((l: RawRecord) => String(l.iso_639_1 ?? '')).filter(Boolean)
				: [],
			certification: extractCertification(raw, mediaType, region),
			imdbId,
			externalLinks: parseExternalLinks(raw.external_ids, homepage),
			providers: extractProviders(raw['watch/providers'], region),
			cast: parsePersonSummaryList(creditsBlock.cast, 'cast'),
			crew: parsePersonSummaryList(creditsBlock.crew, 'crew'),
			seasons,
			recommendations,
			belongsToCollection,
			omdbRatings: []
		} satisfies TitleDetails;
	}) as Promise<TitleDetails | null>;
}

async function fetchTvParentSummary(tvId: number, locale: SupportedLocale): Promise<RawRecord | null> {
	const cacheKey = `tv-parent:${tvId}:${locale}`;
	return tmdbCache.getOrFetch(cacheKey, () =>
		fetchTmdbJson<RawRecord>(`/tv/${tvId}`, { language: toTmdbLanguage(locale) })
	) as Promise<RawRecord | null>;
}

export async function getSeasonDetails(
	tvId: number,
	seasonNumber: number,
	locale: SupportedLocale,
	region: string
): Promise<SeasonDetails | null> {
	const cacheKey = `season:${tvId}:${seasonNumber}:${locale}:${region}`;
	return tmdbCache.getOrFetch(cacheKey, async () => {
		const tmdbLang = toTmdbLanguage(locale);
		const includeLangs = buildIncludeLanguages(locale);

		const [raw, parent] = await Promise.all([
			fetchTmdbJson<RawRecord>(`/tv/${tvId}/season/${seasonNumber}`, {
				append_to_response: 'translations,images,videos,credits',
				language: tmdbLang,
				include_image_language: includeLangs,
				include_video_language: includeLangs
			}),
			fetchTvParentSummary(tvId, locale)
		]);

		if (!raw || !parent) return null;

		let name = String(raw.name ?? '');
		let overview = String(raw.overview ?? '');
		let images = extractTopImages(raw.images?.posters, 10);
		let videos = extractTopYoutubeVideos(raw.videos?.results, 5);

		const baseLang = locale.split('-')[0].toLowerCase();
		const fallbackLocales = Array.from(new Set([baseLang, 'en-US']));

		for (const fbLocale of fallbackLocales) {
			if (overview && (images.length > 0 || videos.length > 0)) break;
			if (fbLocale === tmdbLang.toLowerCase()) continue;

			const brief = await fetchTmdbJson<RawRecord>(`/tv/${tvId}/season/${seasonNumber}`, {
				append_to_response: 'images,videos',
				language: fbLocale,
				include_image_language: `${fbLocale},null,en`,
				include_video_language: `${fbLocale},null,en`
			});
			if (!brief) continue;

			if (!overview && typeof brief.overview === 'string' && brief.overview.trim()) {
				overview = brief.overview.trim();
				if (brief.name) name = String(brief.name);
			}
			if (images.length === 0) {
				images = extractTopImages(brief.images?.posters, 10);
			}
			if (videos.length === 0) {
				videos = extractTopYoutubeVideos(brief.videos?.results, 5);
			}
		}

		const episodes: EpisodeSummary[] = Array.isArray(raw.episodes)
			? raw.episodes.map((ep: RawRecord) => ({
					id: Number(ep.id ?? 0),
					episodeNumber: Number(ep.episode_number ?? 0),
					seasonNumber: Number(ep.season_number ?? seasonNumber),
					name: String(ep.name ?? ''),
					overview: String(ep.overview ?? ''),
					stillPath: ep.still_path ? String(ep.still_path) : null,
					airDate: String(ep.air_date ?? ''),
					runtime: typeof ep.runtime === 'number' && ep.runtime > 0 ? ep.runtime : null,
					voteAverage: Number(ep.vote_average ?? 0),
					voteCount: Number(ep.vote_count ?? 0)
				}))
			: [];

		return {
			id: Number(raw.id ?? 0),
			tvId,
			seriesName: String(parent.name ?? ''),
			seriesPosterPath: parent.poster_path ? String(parent.poster_path) : null,
			seriesBackdropPath: parent.backdrop_path ? String(parent.backdrop_path) : null,
			totalSeasons: Number(parent.number_of_seasons ?? 0),
			seasonNumber: Number(raw.season_number ?? seasonNumber),
			name,
			overview,
			posterPath: raw.poster_path ? String(raw.poster_path) : null,
			airDate: String(raw.air_date ?? ''),
			voteAverage: Number(raw.vote_average ?? 0),
			images,
			videos,
			episodes,
			cast: parsePersonSummaryList(raw.credits?.cast, 'cast'),
			crew: parsePersonSummaryList(raw.credits?.crew, 'crew')
		} satisfies SeasonDetails;
	}) as Promise<SeasonDetails | null>;
}

export async function getEpisodeDetails(
	tvId: number,
	seasonNumber: number,
	episodeNumber: number,
	locale: SupportedLocale,
	region: string
): Promise<EpisodeDetails | null> {
	const cacheKey = `episode:${tvId}:${seasonNumber}:${episodeNumber}:${locale}:${region}`;
	return tmdbCache.getOrFetch(cacheKey, async () => {
		const tmdbLang = toTmdbLanguage(locale);
		const includeLangs = buildIncludeLanguages(locale);

		const [raw, parent, seasonBrief] = await Promise.all([
			fetchTmdbJson<RawRecord>(
				`/tv/${tvId}/season/${seasonNumber}/episode/${episodeNumber}`,
				{
					append_to_response: 'translations,images,videos,credits',
					language: tmdbLang,
					include_image_language: includeLangs,
					include_video_language: includeLangs
				}
			),
			fetchTvParentSummary(tvId, locale),
			fetchTmdbJson<RawRecord>(`/tv/${tvId}/season/${seasonNumber}`, {
				language: tmdbLang
			})
		]);

		if (!raw || !parent) return null;

		let name = String(raw.name ?? '');
		let overview = String(raw.overview ?? '');
		let images = extractTopImages(raw.images?.stills, 10);
		let videos = extractTopYoutubeVideos(raw.videos?.results, 5);

		const baseLang = locale.split('-')[0].toLowerCase();
		const fallbackLocales = Array.from(new Set([baseLang, 'en-US']));

		for (const fbLocale of fallbackLocales) {
			if (overview && (images.length > 0 || videos.length > 0)) break;
			if (fbLocale === tmdbLang.toLowerCase()) continue;

			const brief = await fetchTmdbJson<RawRecord>(
				`/tv/${tvId}/season/${seasonNumber}/episode/${episodeNumber}`,
				{
					append_to_response: 'images,videos',
					language: fbLocale,
					include_image_language: `${fbLocale},null,en`,
					include_video_language: `${fbLocale},null,en`
				}
			);
			if (!brief) continue;

			if (!overview && typeof brief.overview === 'string' && brief.overview.trim()) {
				overview = brief.overview.trim();
				if (brief.name) name = String(brief.name);
			}
			if (images.length === 0) {
				images = extractTopImages(brief.images?.stills, 10);
			}
			if (videos.length === 0) {
				videos = extractTopYoutubeVideos(brief.videos?.results, 5);
			}
		}

		return {
			id: Number(raw.id ?? 0),
			tvId,
			seriesName: String(parent.name ?? ''),
			seasonName: String(seasonBrief?.name ?? ''),
			seasonNumber: Number(raw.season_number ?? seasonNumber),
			episodeNumber: Number(raw.episode_number ?? episodeNumber),
			totalEpisodesInSeason: Array.isArray(seasonBrief?.episodes)
				? seasonBrief.episodes.length
				: 0,
			name,
			overview,
			stillPath: raw.still_path ? String(raw.still_path) : null,
			airDate: String(raw.air_date ?? ''),
			runtime: typeof raw.runtime === 'number' && raw.runtime > 0 ? raw.runtime : null,
			voteAverage: Number(raw.vote_average ?? 0),
			voteCount: Number(raw.vote_count ?? 0),
			images,
			videos,
			cast: parsePersonSummaryList(raw.credits?.cast, 'cast'),
			guestStars: parsePersonSummaryList(raw.guest_stars, 'cast'),
			crew: parsePersonSummaryList(raw.credits?.crew ?? raw.crew, 'crew')
		} satisfies EpisodeDetails;
	}) as Promise<EpisodeDetails | null>;
}

function deduplicateAndSortCredits(
	items: unknown,
	roleField: 'character' | 'job'
): PersonCredit[] {
	if (!Array.isArray(items)) return [];
	const seen = new Set<string>();
	const credits: PersonCredit[] = [];

	for (const raw of items) {
		if (!raw || typeof raw !== 'object' || !raw.id) continue;
		const summary = toTitleSummary(raw);
		const dedupeKey = `${summary.mediaType}_${summary.id}`;
		if (seen.has(dedupeKey)) continue;
		seen.add(dedupeKey);

		credits.push({
			...summary,
			role: String(raw[roleField] ?? ''),
			department: raw.department ? String(raw.department) : undefined
		});
	}

	return credits.sort((a, b) => b.releaseDate.localeCompare(a.releaseDate));
}

export async function getPersonDetails(
	id: number,
	locale: SupportedLocale,
	region: string
): Promise<PersonDetails | null> {
	const cacheKey = `person:${id}:${locale}:${region}`;
	return tmdbCache.getOrFetch(cacheKey, async () => {
		const tmdbLang = toTmdbLanguage(locale);
		const raw = await fetchTmdbJson<RawRecord>(`/person/${id}`, {
			append_to_response: 'combined_credits,images,external_ids,tagged_images',
			language: tmdbLang
		});

		if (!raw) return null;

		let biography = String(raw.biography ?? '').trim();
		const baseLang = locale.split('-')[0].toLowerCase();
		const bioFallbacks = Array.from(new Set([baseLang, 'en-US']));

		for (const fbLocale of bioFallbacks) {
			if (biography) break;
			if (fbLocale === tmdbLang.toLowerCase()) continue;

			const fallbackRaw = await fetchTmdbJson<RawRecord>(`/person/${id}`, {
				language: fbLocale
			});
			if (fallbackRaw?.biography && String(fallbackRaw.biography).trim()) {
				biography = String(fallbackRaw.biography).trim();
			}
		}

		const images: string[] = [];
		const taggedImages: string[] = [];

		if (Array.isArray(raw.images?.profiles)) {
			for (const profile of raw.images.profiles) {
				if (profile?.file_path) {
					const filePath = String(profile.file_path);
					if (!images.includes(filePath)) images.push(filePath);
				}
			}
		}

		if (Array.isArray(raw.tagged_images?.results)) {
			for (const item of raw.tagged_images.results) {
				const aspectRatio = Number(item?.aspect_ratio ?? 1);
				const filePath = item?.file_path ? String(item.file_path) : null;

				if (filePath) {
					if (aspectRatio >= 1) {
						if (!taggedImages.includes(filePath)) taggedImages.push(filePath);
					} else if (!images.includes(filePath)) {
						images.push(filePath);
					}
				}

				const backdropPath = item?.media?.backdrop_path
					? String(item.media.backdrop_path)
					: null;
				if (backdropPath && !taggedImages.includes(backdropPath)) {
					taggedImages.push(backdropPath);
				}
			}
		}

		const imdbId = raw.imdb_id
			? String(raw.imdb_id)
			: raw.external_ids?.imdb_id
				? String(raw.external_ids.imdb_id)
				: null;

		return {
			id: Number(raw.id),
			name: String(raw.name ?? ''),
			knownForDepartment: String(raw.known_for_department ?? ''),
			gender: Number(raw.gender ?? 0),
			alsoKnownAs: Array.isArray(raw.also_known_as)
				? raw.also_known_as.map((name: unknown) => String(name))
				: [],
			profilePath: raw.profile_path ? String(raw.profile_path) : null,
			biography,
			birthday: String(raw.birthday ?? ''),
			deathday: String(raw.deathday ?? ''),
			placeOfBirth: String(raw.place_of_birth ?? ''),
			imdbId,
			externalLinks: parseExternalLinks(
				raw.external_ids,
				raw.homepage ? String(raw.homepage) : undefined
			),
			images,
			taggedImages,
			castCredits: deduplicateAndSortCredits(raw.combined_credits?.cast, 'character'),
			crewCredits: deduplicateAndSortCredits(raw.combined_credits?.crew, 'job')
		} satisfies PersonDetails;
	}) as Promise<PersonDetails | null>;
}

export async function getCollectionDetails(
	id: number,
	locale: SupportedLocale,
	region: string
): Promise<CollectionDetails | null> {
	const cacheKey = `collection:${id}:${locale}:${region}`;
	return tmdbCache.getOrFetch(cacheKey, async () => {
		const tmdbLang = toTmdbLanguage(locale);
		const [raw, translationsRaw, imagesRaw] = await Promise.all([
			fetchTmdbJson<RawRecord>(`/collection/${id}`, { language: tmdbLang }),
			fetchTmdbJson<RawRecord>(`/collection/${id}/translations`),
			fetchTmdbJson<RawRecord>(`/collection/${id}/images`)
		]);

		if (!raw) return null;

		const localized = {
			title: String(raw.name ?? ''),
			overview: String(raw.overview ?? '')
		};

		applyTranslationFallback(
			localized,
			translationsRaw?.translations,
			locale,
			region,
			'collection'
		);

		const parts: TitleSummary[] = Array.isArray(raw.parts)
			? raw.parts
					.map((p: RawRecord) => toTitleSummary(p, 'movie'))
					.sort((a: TitleSummary, b: TitleSummary) => {
						if (!a.releaseDate && !b.releaseDate) return 0;
						if (!a.releaseDate) return 1;
						if (!b.releaseDate) return -1;
						return a.releaseDate.localeCompare(b.releaseDate);
					})
			: [];

		return {
			id: Number(raw.id),
			name: localized.title,
			overview: localized.overview,
			posterPath: raw.poster_path ? String(raw.poster_path) : null,
			backdropPath: raw.backdrop_path ? String(raw.backdrop_path) : null,
			images: extractTopImages(imagesRaw?.backdrops, 10),
			parts
		} satisfies CollectionDetails;
	}) as Promise<CollectionDetails | null>;
}
