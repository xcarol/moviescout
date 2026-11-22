import { error } from '@sveltejs/kit';
import type { SupportedLocale } from '$lib/i18n';
import type { MediaType } from '$lib/types/tmdb';
import { getOmdbRatings } from '../core/omdb';
import { parseTmdbId } from '../core/tmdb-client';
import { buildTitleSeo } from './title-seo';
import { getTitleDetails } from './tmdb-titles';

export async function loadTitleRoute(
	mediaType: MediaType,
	rawId: string,
	locale: SupportedLocale,
	region: string
) {
	const id = parseTmdbId(rawId);
	if (!id) {
		error(404, 'Not found');
	}

	const details = await getTitleDetails(mediaType, id, locale, region);
	if (!details) {
		error(404, 'Not found');
	}

	details.omdbRatings = await getOmdbRatings(details.imdbId);

	return {
		details,
		seo: buildTitleSeo(details)
	};
}
