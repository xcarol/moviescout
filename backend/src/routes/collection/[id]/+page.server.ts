import { error } from '@sveltejs/kit';
import { buildCollectionSeo } from '$lib/server/seo';
import { getCollectionDetails, parseTmdbId } from '$lib/server/tmdb';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params, locals }) => {
	const id = parseTmdbId(params.id);
	if (!id) {
		error(404, 'Not found');
	}

	const collection = await getCollectionDetails(id, locals.locale, locals.region);
	if (!collection) {
		error(404, 'Not found');
	}

	return {
		collection,
		seo: buildCollectionSeo(collection)
	};
};
