import { loadTitleRoute } from '$lib/server/loaders';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params, locals }) => {
	return loadTitleRoute('tv', params.id, locals.locale, locals.region);
};
