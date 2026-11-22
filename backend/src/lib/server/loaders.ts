import { error, redirect } from '@sveltejs/kit';
import type { SupportedLocale } from '$lib/i18n';
import type { MediaType } from '$lib/types/tmdb';
import { getOmdbRatings } from './omdb';
import { buildTitleSeo } from './seo';
import { getTitleDetails, parseTmdbId } from './tmdb';

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

export function redirectToCanonicalEntity(basePath: string, rawId: string): never {
	const id = parseTmdbId(rawId);
	if (!id) {
		error(404, 'Not found');
	}
	redirect(302, `${basePath}/${id}`);
}
