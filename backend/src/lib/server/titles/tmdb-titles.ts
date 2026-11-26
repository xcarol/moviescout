import type { SupportedLocale } from '$lib/i18n';
import type {
	MediaType,
	SeasonSummary,
	TitleDetails,
	TitleSummary,
	WatchProviderItem,
	WatchProviders
} from '$lib/types/tmdb';
import {
	applyTranslationFallback,
	buildIncludeLanguages,
	extractTopImages,
	extractTopYoutubeVideos,
	fetchTmdbJson,
	parseExternalLinks,
	parsePersonSummaryList,
	tmdbCache,
	toTitleSummary,
	toTmdbLanguage,
	type RawRecord
} from '../core/tmdb-client';

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
