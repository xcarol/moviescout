import type { SupportedLocale } from '$lib/i18n';
import type { CollectionDetails, TitleSummary } from '$lib/types/tmdb';
import {
	applyTranslationFallback,
	extractTopImages,
	fetchTmdbJson,
	tmdbCache,
	toTitleSummary,
	toTmdbLanguage,
	type RawRecord
} from '../core/tmdb-client';

export async function getCollectionDetails(
	id: number,
	locale: SupportedLocale,
	region: string
): Promise<CollectionDetails | null> {
	const cacheKey = `collection:${id}:${locale}:${region}`;
	return tmdbCache.getOrFetch(cacheKey, async () => {
		const tmdbLang = toTmdbLanguage(locale);
		const [raw, translationsRaw, imagesRaw] = await Promise.all([
			fetchTmdbJson<RawRecord>(`/collection/${id}`, { language: tmdbLang }),
			fetchTmdbJson<RawRecord>(`/collection/${id}/translations`),
			fetchTmdbJson<RawRecord>(`/collection/${id}/images`)
		]);

		if (!raw) return null;

		const localized = {
			title: String(raw.name ?? ''),
			overview: String(raw.overview ?? '')
		};

		applyTranslationFallback(
			localized,
			translationsRaw?.translations,
			locale,
			region,
			'collection'
		);

		const parts: TitleSummary[] = Array.isArray(raw.parts)
			? raw.parts
					.map((p: RawRecord) => toTitleSummary(p, 'movie'))
					.sort((a: TitleSummary, b: TitleSummary) => {
						if (!a.releaseDate && !b.releaseDate) return 0;
						if (!a.releaseDate) return 1;
						if (!b.releaseDate) return -1;
						return a.releaseDate.localeCompare(b.releaseDate);
					})
			: [];

		return {
			id: Number(raw.id),
			name: localized.title,
			overview: localized.overview,
			posterPath: raw.poster_path ? String(raw.poster_path) : null,
			backdropPath: raw.backdrop_path ? String(raw.backdrop_path) : null,
			images: extractTopImages(imagesRaw?.backdrops, 10),
			parts
		} satisfies CollectionDetails;
	}) as Promise<CollectionDetails | null>;
}
