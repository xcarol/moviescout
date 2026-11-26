import { error, redirect } from '@sveltejs/kit';
import { parseTmdbId } from './tmdb-client';

export function redirectToCanonicalEntity(basePath: string, rawId: string): never {
	const id = parseTmdbId(rawId);
	if (!id) {
		error(404, 'Not found');
	}
	redirect(302, `${basePath}/${id}`);
}
