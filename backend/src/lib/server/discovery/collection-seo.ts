import { APP_NAME } from '$lib/constants/app';
import { SITE_URL, TMDB_IMAGE_SIZE } from '$lib/constants/urls';
import type { CollectionDetails } from '$lib/types/tmdb';
import { resolveOgImage } from '../core/seo';

export function buildCollectionSeo(collection: CollectionDetails) {
	const title = `${collection.name} — ${APP_NAME}`;
	const description = collection.overview || collection.name;
	const canonicalPath = `/collection/${collection.id}`;
	const imagePath = collection.backdropPath ?? collection.posterPath;
	const ogImage = resolveOgImage(imagePath, TMDB_IMAGE_SIZE.w780);

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': 'CollectionPage',
		name: collection.name,
		url: `${SITE_URL}${canonicalPath}`,
		description,
		mainEntity: {
			'@type': 'ItemList',
			numberOfItems: collection.parts.length,
			itemListElement: collection.parts.map((part, index) => ({
				'@type': 'ListItem',
				position: index + 1,
				item: {
					'@type': 'Movie',
					name: part.title,
					url: `${SITE_URL}/movie/${part.id}`
				}
			}))
		}
	};

	return { title, description, canonicalPath, ogImage, jsonLd };
}
