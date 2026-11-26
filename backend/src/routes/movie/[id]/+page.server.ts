import { loadTitleRoute } from '$lib/server/titles/title-loader';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ params, locals }) => {
	return loadTitleRoute('movie', params.id, locals.locale, locals.region);
};
