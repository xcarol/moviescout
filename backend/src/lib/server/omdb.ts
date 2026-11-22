import { env } from '$env/dynamic/private';
import { OMDB_CACHE_TTL_MS, OMDB_TIMEOUT_MS } from '$lib/constants/app';
import { OMDB_API_URL } from '$lib/constants/urls';
import type { OmdbRating } from '$lib/types/tmdb';
import { TtlLruCache } from './cache';

const omdbCache = new TtlLruCache<OmdbRating[]>({
	maxEntries: 500,
	defaultTtlMs: OMDB_CACHE_TTL_MS
});

function normalizeOmdbValue(source: string, value: string): string {
	if (source === 'Internet Movie Database' && value.includes('/')) {
		const num = Number.parseFloat(value.split('/')[0]);
		if (!Number.isNaN(num)) {
			return num === 10 ? '10' : num.toFixed(1);
		}
	} else if (source === 'Rotten Tomatoes' && value.includes('%')) {
		const num = Number.parseFloat(value.replace('%', ''));
		if (!Number.isNaN(num)) {
			const scaled = num / 10;
			return scaled === 10 ? '10' : scaled.toFixed(1);
		}
	} else if (source === 'Metacritic' && value.includes('/')) {
		const num = Number.parseFloat(value.split('/')[0]);
		if (!Number.isNaN(num)) {
			const scaled = num / 10;
			return scaled === 10 ? '10' : scaled.toFixed(1);
		}
	}
	return value;
}

function getLogoAsset(source: string): string | null {
	switch (source) {
		case 'Internet Movie Database':
			return '/assets/imdb-logo.png';
		case 'Rotten Tomatoes':
			return '/assets/rotten-logo.png';
		case 'Metacritic':
			return '/assets/metacritic-logo.png';
		default:
			return null;
	}
}

export async function getOmdbRatings(imdbId?: string | null): Promise<OmdbRating[]> {
	if (!imdbId) return [];

	const apiKey = env.OMDB_API_KEY?.trim();
	if (!apiKey) return [];

	return omdbCache.getOrFetch(
		imdbId,
		async () => {
			const url = new URL(OMDB_API_URL);
			url.searchParams.set('i', imdbId);
			url.searchParams.set('apikey', apiKey);

			try {
				const response = await fetch(url, {
					signal: AbortSignal.timeout(OMDB_TIMEOUT_MS)
				});
				if (!response.ok) return [];

				const data = (await response.json()) as {
					Response?: string;
					Ratings?: Array<{ Source?: string; Value?: string }>;
				};

				if (data.Response !== 'True' || !Array.isArray(data.Ratings)) {
					return [];
				}

				return data.Ratings.filter((item) => item.Source && item.Value).map((item) => {
					const source = item.Source!;
					const rawValue = item.Value!;
					return {
						source,
						rawValue,
						normalizedValue: normalizeOmdbValue(source, rawValue),
						logoAsset: getLogoAsset(source)
					};
				});
			} catch {
				return [];
			}
		},
		{ shouldCache: (ratings) => ratings.length > 0 }
	);
}
