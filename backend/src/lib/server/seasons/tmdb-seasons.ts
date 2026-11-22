import type { SupportedLocale } from '$lib/i18n';
import type { EpisodeDetails, EpisodeSummary, SeasonDetails } from '$lib/types/tmdb';
import {
	buildIncludeLanguages,
	extractTopImages,
	extractTopYoutubeVideos,
	fetchTmdbJson,
	parsePersonSummaryList,
	tmdbCache,
	toTmdbLanguage,
	type RawRecord
} from '../core/tmdb-client';

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
