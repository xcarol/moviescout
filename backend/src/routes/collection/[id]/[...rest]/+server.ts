import { redirectToCanonicalEntity } from '$lib/server/loaders';
import type { RequestHandler } from './$types';

export const GET: RequestHandler = ({ params }) => {
	redirectToCanonicalEntity('/collection', params.id);
};
