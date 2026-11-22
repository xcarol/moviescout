import { error } from '@sveltejs/kit';
import { buildSeasonSeo } from '$lib/server/seo';
import { getSeasonDetails, parseSeasonNumber, parseTmdbId } from '$lib/server/tmdb';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params, locals }) => {
	const tvId = parseTmdbId(params.id);
	const seasonNumber = parseSeasonNumber(params.seasonNumber);
	if (!tvId || seasonNumber === null) {
		error(404, 'Not found');
	}

	const season = await getSeasonDetails(tvId, seasonNumber, locals.locale, locals.region);
	if (!season) {
		error(404, 'Not found');
	}

	return {
		season,
		seo: buildSeasonSeo(season)
	};
};
