import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import {
	LANG_COOKIE_NAME,
	PREFERENCE_COOKIE_MAX_AGE_SECONDS,
	REGION_COOKIE_NAME
} from '$lib/constants/app';
import { normalizeLocaleTag, normalizeRegionCode } from '$lib/i18n';

export const POST: RequestHandler = async ({ request, cookies, url, locals }) => {
	let payload: { lang?: unknown; region?: unknown };
	try {
		payload = (await request.json()) as { lang?: unknown; region?: unknown };
	} catch {
		return json({ error: 'Invalid JSON payload' }, { status: 400 });
	}

	const cookieOptions = {
		path: '/',
		sameSite: 'lax' as const,
		maxAge: PREFERENCE_COOKIE_MAX_AGE_SECONDS,
		httpOnly: false,
		secure: url.protocol === 'https:'
	};

	let nextLocale = locals.locale;
	let nextRegion = locals.region;

	if ('lang' in payload) {
		if (payload.lang === null || payload.lang === '') {
			cookies.delete(LANG_COOKIE_NAME, { path: '/' });
		} else if (typeof payload.lang === 'string') {
			const normalized = normalizeLocaleTag(payload.lang);
			if (!normalized) {
				return json({ error: 'Unsupported language' }, { status: 400 });
			}
			cookies.set(LANG_COOKIE_NAME, normalized, cookieOptions);
			nextLocale = normalized;
		} else {
			return json({ error: 'Invalid language value' }, { status: 400 });
		}
	}

	if ('region' in payload) {
		if (payload.region === null || payload.region === '') {
			cookies.delete(REGION_COOKIE_NAME, { path: '/' });
		} else if (typeof payload.region === 'string') {
			const normalized = normalizeRegionCode(payload.region);
			if (!normalized) {
				return json({ error: 'Invalid region code' }, { status: 400 });
			}
			cookies.set(REGION_COOKIE_NAME, normalized, cookieOptions);
			nextRegion = normalized;
		} else {
			return json({ error: 'Invalid region value' }, { status: 400 });
		}
	}

	return json(
		{ locale: nextLocale, region: nextRegion },
		{
			headers: {
				'cache-control': 'no-store'
			}
		}
	);
};
