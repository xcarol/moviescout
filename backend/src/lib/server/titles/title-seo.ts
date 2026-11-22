import { APP_NAME } from '$lib/constants/app';
import { SITE_URL, TMDB_IMAGE_SIZE, tmdbImageUrl } from '$lib/constants/urls';
import type { TitleDetails } from '$lib/types/tmdb';
import { buildAggregateRating, resolveOgImage } from '../core/seo';

export function buildTitleSeo(details: TitleDetails) {
	const year = details.releaseDate ? details.releaseDate.slice(0, 4) : '';
	const title = year ? `${details.title} (${year}) — ${APP_NAME}` : `${details.title} — ${APP_NAME}`;
	const description = details.overview || details.tagline || details.title;
	const canonicalPath = `/${details.mediaType}/${details.id}`;
	const ogImage = details.backdropPath
		? resolveOgImage(details.backdropPath, TMDB_IMAGE_SIZE.w780)
		: resolveOgImage(details.posterPath, TMDB_IMAGE_SIZE.w500);

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': details.mediaType === 'movie' ? 'Movie' : 'TVSeries',
		name: details.title,
		url: `${SITE_URL}${canonicalPath}`,
		description
	};

	if (details.posterPath) {
		jsonLd.image = tmdbImageUrl(details.posterPath, TMDB_IMAGE_SIZE.w500);
	}
	if (details.releaseDate) {
		jsonLd.datePublished = details.releaseDate;
	}
	if (details.genres.length > 0) {
		jsonLd.genre = details.genres.map((g) => g.name);
	}
	if (details.mediaType === 'tv') {
		if (details.numberOfSeasons) jsonLd.numberOfSeasons = details.numberOfSeasons;
		if (details.numberOfEpisodes) jsonLd.numberOfEpisodes = details.numberOfEpisodes;
	}
	const aggregateRating = buildAggregateRating(details.voteAverage, details.voteCount);
	if (aggregateRating) {
		jsonLd.aggregateRating = aggregateRating;
	}

	return {
		title,
		description,
		canonicalPath,
		ogType: details.mediaType === 'movie' ? ('video.movie' as const) : ('video.tv_show' as const),
		ogImage,
		jsonLd
	};
}
