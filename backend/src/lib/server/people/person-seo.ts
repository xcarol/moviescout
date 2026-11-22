import { APP_NAME } from '$lib/constants/app';
import { SITE_URL, TMDB_IMAGE_SIZE, tmdbImageUrl } from '$lib/constants/urls';
import type { PersonDetails } from '$lib/types/tmdb';
import { resolveOgImage } from '../core/seo';

export function buildPersonSeo(person: PersonDetails) {
	const title = `${person.name} — ${APP_NAME}`;
	const description = person.biography || person.name;
	const canonicalPath = `/person/${person.id}`;
	const ogImage = resolveOgImage(person.profilePath, TMDB_IMAGE_SIZE.w500);

	const jsonLd: Record<string, unknown> = {
		'@context': 'https://schema.org',
		'@type': 'Person',
		name: person.name,
		url: `${SITE_URL}${canonicalPath}`,
		description
	};

	if (person.profilePath) {
		jsonLd.image = tmdbImageUrl(person.profilePath, TMDB_IMAGE_SIZE.w500);
	}
	if (person.birthday) jsonLd.birthDate = person.birthday;
	if (person.deathday) jsonLd.deathDate = person.deathday;
	if (person.knownForDepartment) jsonLd.jobTitle = person.knownForDepartment;

	return { title, description, canonicalPath, ogImage, jsonLd };
}
