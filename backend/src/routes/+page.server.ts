import { buildLandingSeo } from '$lib/server/seo';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	return {
		seo: buildLandingSeo(locals.locale)
	};
};
