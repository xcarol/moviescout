import type { SupportedLocale } from '$lib/i18n';
import type { PersonCredit, PersonDetails } from '$lib/types/tmdb';
import {
	fetchTmdbJson,
	parseExternalLinks,
	tmdbCache,
	toTitleSummary,
	toTmdbLanguage,
	type RawRecord
} from '../core/tmdb-client';

function deduplicateAndSortCredits(
	items: unknown,
	roleField: 'character' | 'job'
): PersonCredit[] {
	if (!Array.isArray(items)) return [];
	const seen = new Set<string>();
	const credits: PersonCredit[] = [];

	for (const raw of items) {
		if (!raw || typeof raw !== 'object' || !raw.id) continue;
		const summary = toTitleSummary(raw);
		const dedupeKey = `${summary.mediaType}_${summary.id}`;
		if (seen.has(dedupeKey)) continue;
		seen.add(dedupeKey);

		credits.push({
			...summary,
			role: String(raw[roleField] ?? ''),
			department: raw.department ? String(raw.department) : undefined
		});
	}

	return credits.sort((a, b) => b.releaseDate.localeCompare(a.releaseDate));
}

export async function getPersonDetails(
	id: number,
	locale: SupportedLocale,
	region: string
): Promise<PersonDetails | null> {
	const cacheKey = `person:${id}:${locale}:${region}`;
	return tmdbCache.getOrFetch(cacheKey, async () => {
		const tmdbLang = toTmdbLanguage(locale);
		const raw = await fetchTmdbJson<RawRecord>(`/person/${id}`, {
			append_to_response: 'combined_credits,images,external_ids,tagged_images',
			language: tmdbLang
		});

		if (!raw) return null;

		let biography = String(raw.biography ?? '').trim();
		const baseLang = locale.split('-')[0].toLowerCase();
		const bioFallbacks = Array.from(new Set([baseLang, 'en-US']));

		for (const fbLocale of bioFallbacks) {
			if (biography) break;
			if (fbLocale === tmdbLang.toLowerCase()) continue;

			const fallbackRaw = await fetchTmdbJson<RawRecord>(`/person/${id}`, {
				language: fbLocale
			});
			if (fallbackRaw?.biography && String(fallbackRaw.biography).trim()) {
				biography = String(fallbackRaw.biography).trim();
			}
		}

		const images: string[] = [];
		const taggedImages: string[] = [];

		if (Array.isArray(raw.images?.profiles)) {
			for (const profile of raw.images.profiles) {
				if (profile?.file_path) {
					const filePath = String(profile.file_path);
					if (!images.includes(filePath)) images.push(filePath);
				}
			}
		}

		if (Array.isArray(raw.tagged_images?.results)) {
			for (const item of raw.tagged_images.results) {
				const aspectRatio = Number(item?.aspect_ratio ?? 1);
				const filePath = item?.file_path ? String(item.file_path) : null;

				if (filePath) {
					if (aspectRatio >= 1) {
						if (!taggedImages.includes(filePath)) taggedImages.push(filePath);
					} else if (!images.includes(filePath)) {
						images.push(filePath);
					}
				}

				const backdropPath = item?.media?.backdrop_path
					? String(item.media.backdrop_path)
					: null;
				if (backdropPath && !taggedImages.includes(backdropPath)) {
					taggedImages.push(backdropPath);
				}
			}
		}

		const imdbId = raw.imdb_id
			? String(raw.imdb_id)
			: raw.external_ids?.imdb_id
				? String(raw.external_ids.imdb_id)
				: null;

		return {
			id: Number(raw.id),
			name: String(raw.name ?? ''),
			knownForDepartment: String(raw.known_for_department ?? ''),
			gender: Number(raw.gender ?? 0),
			alsoKnownAs: Array.isArray(raw.also_known_as)
				? raw.also_known_as.map((name: unknown) => String(name))
				: [],
			profilePath: raw.profile_path ? String(raw.profile_path) : null,
			biography,
			birthday: String(raw.birthday ?? ''),
			deathday: String(raw.deathday ?? ''),
			placeOfBirth: String(raw.place_of_birth ?? ''),
			imdbId,
			externalLinks: parseExternalLinks(
				raw.external_ids,
				raw.homepage ? String(raw.homepage) : undefined
			),
			images,
			taggedImages,
			castCredits: deduplicateAndSortCredits(raw.combined_credits?.cast, 'character'),
			crewCredits: deduplicateAndSortCredits(raw.combined_credits?.crew, 'job')
		} satisfies PersonDetails;
	}) as Promise<PersonDetails | null>;
}
