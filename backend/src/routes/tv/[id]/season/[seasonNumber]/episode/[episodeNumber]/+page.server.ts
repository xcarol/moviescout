import { error } from '@sveltejs/kit';
import { parseTmdbId } from '$lib/server/core/tmdb-client';
import { buildEpisodeSeo } from '$lib/server/seasons/season-seo';
import {
	getEpisodeDetails,
	parseEpisodeNumber,
	parseSeasonNumber
} from '$lib/server/seasons/tmdb-seasons';
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
