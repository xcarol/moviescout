import { redirectToCanonicalEntity } from '$lib/server/core/routing';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = ({ params }) => {
	redirectToCanonicalEntity('/tv', params.id);
};
