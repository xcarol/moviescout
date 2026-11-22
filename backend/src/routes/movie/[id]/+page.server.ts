import { loadTitleRoute } from '$lib/server/loaders';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params, locals }) => {
	return loadTitleRoute('movie', params.id, locals.locale, locals.region);
};
