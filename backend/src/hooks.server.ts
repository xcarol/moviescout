import type { Handle } from '@sveltejs/kit';
import { resolveLocale, resolveRegion } from '$lib/i18n';

export const handle: Handle = async ({ event, resolve }) => {
	const langOverride = event.url.searchParams.get('lang') || event.cookies.get('ms_lang');
	const regionOverride =
		event.url.searchParams.get('region') || event.cookies.get('ms_region');

	const locale = resolveLocale(event.request.headers.get('accept-language'), langOverride);
	const region = resolveRegion(
		event.request.headers.get('x-vercel-ip-country'),
		locale,
		regionOverride
	);

	const hasCustomPrefs = Boolean(
		event.cookies.get('ms_lang') ||
			event.cookies.get('ms_region') ||
			event.url.searchParams.get('lang') ||
			event.url.searchParams.get('region')
	);

	event.locals.locale = locale;
	event.locals.region = region;
	event.locals.hasCustomPrefs = hasCustomPrefs;

	const response = await resolve(event, {
		transformPageChunk: ({ html }) => html.replace('%lang%', locale)
	});

	if (!event.url.pathname.startsWith('/api/') && !response.headers.has('cache-control')) {
		const isHtml = response.headers.get('content-type')?.includes('text/html');
		if (hasCustomPrefs) {
			response.headers.set('cache-control', 'private, no-store');
		} else if (response.status === 200 && isHtml) {
			response.headers.set(
				'cache-control',
				'public, s-maxage=1800, stale-while-revalidate=86400'
			);
			response.headers.append('vary', 'Accept-Language');
		}
	}

	return response;
};
