import { error } from '@sveltejs/kit';
import { buildEpisodeSeo } from '$lib/server/seo';
import {
	getEpisodeDetails,
	parseEpisodeNumber,
	parseSeasonNumber,
	parseTmdbId
} from '$lib/server/tmdb';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params, locals }) => {
	const tvId = parseTmdbId(params.id);
	const seasonNumber = parseSeasonNumber(params.seasonNumber);
	const episodeNumber = parseEpisodeNumber(params.episodeNumber);
	if (!tvId || seasonNumber === null || !episodeNumber) {
		error(404, 'Not found');
	}

	const episode = await getEpisodeDetails(
		tvId,
		seasonNumber,
		episodeNumber,
		locals.locale,
		locals.region
	);
	if (!episode) {
		error(404, 'Not found');
	}

	return {
		episode,
		seo: buildEpisodeSeo(episode)
	};
};
