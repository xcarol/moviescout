import { APP_NAME } from '$lib/constants/app';
import { SITE_URL, TMDB_IMAGE_SIZE, tmdbImageUrl } from '$lib/constants/urls';
import type { EpisodeDetails, SeasonDetails } from '$lib/types/tmdb';
import { buildAggregateRating, resolveOgImage } from '../core/seo';

export function buildSeasonSeo(season: SeasonDetails) {
	const title = `${season.seriesName} — ${season.name} — ${APP_NAME}`;
	const description = season.overview || `${season.seriesName} · ${season.name}`;
	const canonicalPath = `/tv/${season.tvId}/season/${season.seasonNumber}`;
	const imagePath = season.posterPath ?? season.seriesBackdropPath ?? season.seriesPosterPath;
	const ogImage = resolveOgImage(imagePath, TMDB_IMAGE_SIZE.w780);

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': 'TVSeason',
		name: season.name,
		seasonNumber: season.seasonNumber,
		numberOfEpisodes: season.episodes.length,
		url: `${SITE_URL}${canonicalPath}`,
		description,
		partOfSeries: {
			'@type': 'TVSeries',
			name: season.seriesName,
			url: `${SITE_URL}/tv/${season.tvId}`
		}
	};

	if (season.airDate) jsonLd.datePublished = season.airDate;
	if (season.posterPath) {
		jsonLd.image = tmdbImageUrl(season.posterPath, TMDB_IMAGE_SIZE.w500);
	}

	return { title, description, canonicalPath, ogImage, jsonLd };
}

export function buildEpisodeSeo(episode: EpisodeDetails) {
	const code = `S${String(episode.seasonNumber).padStart(2, '0')}E${String(episode.episodeNumber).padStart(2, '0')}`;
	const title = `${episode.seriesName} ${code}: ${episode.name} — ${APP_NAME}`;
	const description = episode.overview || `${episode.seriesName} ${code} — ${episode.name}`;
	const canonicalPath = `/tv/${episode.tvId}/season/${episode.seasonNumber}/episode/${episode.episodeNumber}`;
	const ogImage = resolveOgImage(episode.stillPath, TMDB_IMAGE_SIZE.w780);

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': 'TVEpisode',
		name: episode.name,
		episodeNumber: episode.episodeNumber,
		url: `${SITE_URL}${canonicalPath}`,
		description,
		partOfSeason: {
			'@type': 'TVSeason',
			seasonNumber: episode.seasonNumber,
			url: `${SITE_URL}/tv/${episode.tvId}/season/${episode.seasonNumber}`
		},
		partOfSeries: {
			'@type': 'TVSeries',
			name: episode.seriesName,
			url: `${SITE_URL}/tv/${episode.tvId}`
		}
	};

	if (episode.airDate) jsonLd.datePublished = episode.airDate;
	if (episode.stillPath) {
		jsonLd.image = tmdbImageUrl(episode.stillPath, TMDB_IMAGE_SIZE.w780);
	}
	const aggregateRating = buildAggregateRating(episode.voteAverage, episode.voteCount);
	if (aggregateRating) {
		jsonLd.aggregateRating = aggregateRating;
	}

	return { title, description, canonicalPath, ogImage, jsonLd };
}
