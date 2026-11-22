import { error } from '@sveltejs/kit';
import { buildPersonSeo } from '$lib/server/seo';
import { getPersonDetails, parseTmdbId } from '$lib/server/tmdb';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params, locals }) => {
	const id = parseTmdbId(params.id);
	if (!id) {
		error(404, 'Not found');
	}

	const person = await getPersonDetails(id, locals.locale, locals.region);
	if (!person) {
		error(404, 'Not found');
	}

	return {
		person,
		seo: buildPersonSeo(person)
	};
};
