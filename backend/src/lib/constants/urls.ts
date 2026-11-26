export type TmdbImageSize = 'w45' | 'w185' | 'w300' | 'w500' | 'w780' | 'original';

export const TMDB_IMAGE_SIZE = {
	w45: 'w45',
	w185: 'w185',
	w300: 'w300',
	w500: 'w500',
	w780: 'w780',
	original: 'original'
} as const satisfies Record<TmdbImageSize, TmdbImageSize>;

export const SITE_URL = 'https://moviescout.xicra.com';
export const DEFAULT_OG_IMAGE_URL = `${SITE_URL}/imatge-destacada.png`;

export const GOOGLE_PLAY_URL =
	'https://play.google.com/store/apps/details?id=com.xicra.moviescout';
export const GITHUB_REPO_URL = 'https://github.com/xcarol/moviescout';

export const TMDB_API_BASE_URL = 'https://api.themoviedb.org/3';
export const TMDB_WEB_URL = 'https://www.themoviedb.org';
export const TMDB_IMAGE_BASE_URL = 'https://image.tmdb.org/t/p';
export const JUSTWATCH_WEB_URL = 'https://www.justwatch.com';
export const OMDB_API_URL = 'https://www.omdbapi.com/';
export const IMDB_WEB_URL = 'https://www.imdb.com';
export const YOUTUBE_EMBED_BASE_URL = 'https://www.youtube-nocookie.com/embed';

export const PRIVACY_POLICY_PATH = '/privacy.html';
export const TERMS_OF_SERVICE_PATH = '/terms.html';

export const LOGO_ICON_ASSET = '/assets/logo-icon.png';
export const TMDB_LOGO_ASSET = '/assets/tmdb-logo.png';
export const ERROR_NETWORK_ASSET = '/assets/error-network.png';

export function tmdbImageUrl(path: string, size: TmdbImageSize = 'w500'): string {
	const normalizedPath = path.startsWith('/') ? path : `/${path}`;
	return `${TMDB_IMAGE_BASE_URL}/${size}${normalizedPath}`;
}

export function youtubeEmbedUrl(key: string): string {
	return `${YOUTUBE_EMBED_BASE_URL}/${key}?autoplay=1&rel=0`;
}
