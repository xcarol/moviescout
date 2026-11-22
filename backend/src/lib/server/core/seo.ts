import { APP_NAME } from '$lib/constants/app';
import {
	DEFAULT_OG_IMAGE_URL,
	GOOGLE_PLAY_URL,
	SITE_URL,
	TMDB_IMAGE_SIZE,
	tmdbImageUrl,
	type TmdbImageSize
} from '$lib/constants/urls';
import { tw, type SupportedLocale } from '$lib/i18n';

export function resolveOgImage(
	path?: string | null,
	size: TmdbImageSize = TMDB_IMAGE_SIZE.w780
): string {
	return path ? tmdbImageUrl(path, size) : DEFAULT_OG_IMAGE_URL;
}

export function buildAggregateRating(voteAverage: number, voteCount: number) {
	if (voteCount <= 0 || voteAverage <= 0) return undefined;
	return {
		'@type': 'AggregateRating',
		ratingValue: Number(voteAverage.toFixed(1)),
		bestRating: 10,
		worstRating: 1,
		ratingCount: voteCount
	};
}

export function buildLandingSeo(locale: SupportedLocale) {
	const title = `${APP_NAME} — ${tw(locale, 'landingMotto')}`;
	const description = tw(locale, 'landingSubtitle');

	return {
		title,
		description,
		canonicalPath: '/',
		ogImage: DEFAULT_OG_IMAGE_URL,
		jsonLd: {
			'@context': 'https://schema.org',
			'@type': 'SoftwareApplication',
			name: APP_NAME,
			applicationCategory: 'EntertainmentApplication',
			operatingSystem: 'Android',
			url: SITE_URL,
			downloadUrl: GOOGLE_PLAY_URL,
			image: DEFAULT_OG_IMAGE_URL,
			description
		}
	};
}
