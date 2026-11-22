import { env } from '$env/dynamic/private';
import { TMDB_CACHE_TTL_MS, TMDB_TIMEOUT_MS } from '$lib/constants/app';
import { TMDB_API_BASE_URL } from '$lib/constants/urls';
import type { SupportedLocale } from '$lib/i18n';
import type {
	ExternalLinks,
	MediaType,
	PersonSummary,
	TitleSummary,
	TmdbVideo
} from '$lib/types/tmdb';
import { TtlLruCache } from './cache';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type RawRecord = Record<string, any>;

export const tmdbCache = new TtlLruCache<unknown>({
	maxEntries: 600,
	defaultTtlMs: TMDB_CACHE_TTL_MS
});

export class TmdbConfigError extends Error {
	constructor(message = 'TMDB_API_RAT environment variable is not configured') {
		super(message);
		this.name = 'TmdbConfigError';
	}
}

export class TmdbUpstreamError extends Error {
	readonly status: number;

	constructor(status: number, path: string) {
		super(`TMDB API request failed (${status}) for ${path}`);
		this.name = 'TmdbUpstreamError';
		this.status = status;
	}
}

export function parseTmdbId(rawParam: string): number | null {
	const match = /^(\d+)(?:-.*)?$/.exec(rawParam.trim());
	if (!match) return null;
	const parsed = Number.parseInt(match[1], 10);
	return Number.isSafeInteger(parsed) && parsed > 0 ? parsed : null;
}

export function toTmdbLanguage(locale: SupportedLocale): string {
	// TMDB uses es-MX rather than es-419 for Latin American Spanish.
	return locale === 'es-419' ? 'es-MX' : locale;
}

export function buildIncludeLanguages(locale: SupportedLocale): string {
	const tmdbLang = toTmdbLanguage(locale);
	const baseLang = locale.split('-')[0];
	return Array.from(new Set([tmdbLang, baseLang, 'null', 'en'])).join(',');
}

export async function fetchTmdbJson<T>(
	path: string,
	params: Record<string, string> = {}
): Promise<T | null> {
	const token = env.TMDB_API_RAT?.trim();
	if (!token) {
		throw new TmdbConfigError();
	}

	const url = new URL(`${TMDB_API_BASE_URL}${path}`);
	for (const [key, value] of Object.entries(params)) {
		if (value) url.searchParams.set(key, value);
	}

	const response = await fetch(url, {
		headers: {
			Authorization: `Bearer ${token}`,
			Accept: 'application/json'
		},
		signal: AbortSignal.timeout(TMDB_TIMEOUT_MS)
	});

	if (response.status === 404) return null;
	if (!response.ok) {
		throw new TmdbUpstreamError(response.status, path);
	}

	return (await response.json()) as T;
}

export function extractTopImages(items: unknown, limit = 10): string[] {
	if (!Array.isArray(items)) return [];
	return [...items]
		.filter((item): item is RawRecord => Boolean(item && typeof item === 'object' && item.file_path))
		.sort((a, b) => Number(b.vote_average ?? 0) - Number(a.vote_average ?? 0))
		.slice(0, limit)
		.map((item) => String(item.file_path));
}

export function extractTopYoutubeVideos(items: unknown, limit = 5): TmdbVideo[] {
	if (!Array.isArray(items)) return [];
	return [...items]
		.filter(
			(item): item is RawRecord =>
				Boolean(
					item &&
						typeof item === 'object' &&
						item.key &&
						String(item.site ?? '').toLowerCase() === 'youtube'
				)
		)
		.sort((a, b) => {
			const aOfficial = a.official === true ? 1 : 0;
			const bOfficial = b.official === true ? 1 : 0;
			if (aOfficial !== bOfficial) return bOfficial - aOfficial;

			const aTrailer = a.type === 'Trailer' ? 1 : 0;
			const bTrailer = b.type === 'Trailer' ? 1 : 0;
			return bTrailer - aTrailer;
		})
		.slice(0, limit)
		.map((v) => ({
			key: String(v.key),
			site: String(v.site ?? 'YouTube'),
			name: String(v.name ?? ''),
			iso6391: v.iso_639_1 ? String(v.iso_639_1) : null,
			official: Boolean(v.official),
			type: String(v.type ?? '')
		}));
}

export function parsePersonSummaryList(items: unknown, roleType: 'cast' | 'crew'): PersonSummary[] {
	if (!Array.isArray(items)) return [];
	const people: PersonSummary[] = [];
	const indexById = new Map<number, number>();

	for (const raw of items) {
		if (!raw || typeof raw !== 'object') continue;
		const id = Number(raw.id ?? 0);
		if (!id) continue;

		let role = '';
		if (roleType === 'cast') {
			if (Array.isArray(raw.roles)) {
				role = raw.roles
					.map((r: RawRecord) => String(r?.character ?? ''))
					.filter(Boolean)
					.join(', ');
			} else {
				role = String(raw.character ?? '');
			}
		} else {
			if (Array.isArray(raw.jobs)) {
				role = raw.jobs
					.map((j: RawRecord) => String(j?.job ?? ''))
					.filter(Boolean)
					.join(', ');
			} else {
				role = String(raw.job ?? '');
			}
		}

		const existingIndex = indexById.get(id);
		if (existingIndex !== undefined) {
			const existing = people[existingIndex];
			if (role && !existing.role.includes(role)) {
				existing.role = existing.role ? `${existing.role}, ${role}` : role;
			}
			continue;
		}

		indexById.set(id, people.length);
		people.push({
			id,
			name: String(raw.name ?? ''),
			profilePath: raw.profile_path ? String(raw.profile_path) : null,
			role,
			department: raw.known_for_department
				? String(raw.known_for_department)
				: raw.department
					? String(raw.department)
					: undefined,
			order: typeof raw.order === 'number' ? raw.order : undefined
		});
	}

	return people;
}

export function parseExternalLinks(
	rawExternalIds: RawRecord | undefined,
	homepage?: string
): ExternalLinks {
	return {
		imdbId: rawExternalIds?.imdb_id ? String(rawExternalIds.imdb_id) : undefined,
		wikidataId: rawExternalIds?.wikidata_id ? String(rawExternalIds.wikidata_id) : undefined,
		facebookId: rawExternalIds?.facebook_id ? String(rawExternalIds.facebook_id) : undefined,
		instagramId: rawExternalIds?.instagram_id ? String(rawExternalIds.instagram_id) : undefined,
		twitterId: rawExternalIds?.twitter_id ? String(rawExternalIds.twitter_id) : undefined,
		tiktokId: rawExternalIds?.tiktok_id ? String(rawExternalIds.tiktok_id) : undefined,
		youtubeId: rawExternalIds?.youtube_id ? String(rawExternalIds.youtube_id) : undefined,
		homepage: homepage || undefined
	};
}

export function applyTranslationFallback(
	target: { title: string; overview: string },
	translations: unknown,
	locale: SupportedLocale,
	region: string,
	mediaType: MediaType | 'collection'
): void {
	if (!Array.isArray(translations)) return;
	const fallbacks = Array.from(
		new Set([locale.split('-')[0].toLowerCase(), region.toLowerCase(), 'en'])
	);

	for (const lang of fallbacks) {
		if (target.overview && target.title) break;
		const match = translations.find(
			(item: RawRecord) => String(item?.iso_639_1 ?? '').toLowerCase() === lang
		);
		const data = match?.data as RawRecord | undefined;
		if (!data) continue;

		if (!target.overview && typeof data.overview === 'string' && data.overview.trim()) {
			target.overview = data.overview.trim();
		}

		const candidateTitle =
			mediaType === 'movie'
				? data.title
				: mediaType === 'tv'
					? data.name
					: data.name || data.title;
		if (!target.title && typeof candidateTitle === 'string' && candidateTitle.trim()) {
			target.title = candidateTitle.trim();
		}
	}
}

export function toTitleSummary(raw: RawRecord, forcedMediaType?: MediaType): TitleSummary {
	const mediaType: MediaType =
		forcedMediaType ?? (raw.media_type === 'tv' || (!raw.title && raw.name) ? 'tv' : 'movie');
	return {
		id: Number(raw.id),
		mediaType,
		title: String(raw.title ?? raw.name ?? ''),
		originalTitle: String(raw.original_title ?? raw.original_name ?? ''),
		posterPath: raw.poster_path ? String(raw.poster_path) : null,
		backdropPath: raw.backdrop_path ? String(raw.backdrop_path) : null,
		releaseDate: String(raw.release_date ?? raw.first_air_date ?? ''),
		voteAverage: Number(raw.vote_average ?? 0),
		voteCount: Number(raw.vote_count ?? 0),
		overview: String(raw.overview ?? ''),
		genreIds: Array.isArray(raw.genre_ids)
			? raw.genre_ids.map((id: unknown) => Number(id)).filter((id: number) => !Number.isNaN(id))
			: []
	};
}
