import { error } from '@sveltejs/kit';
import { parseTmdbId } from '$lib/server/core/tmdb-client';
import { buildPersonSeo } from '$lib/server/people/person-seo';
import { getPersonDetails } from '$lib/server/people/tmdb-people';
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
