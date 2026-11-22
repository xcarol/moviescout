import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { normalizeLocaleTag, normalizeRegionCode } from '$lib/i18n';

const ONE_YEAR_SECONDS = 31_536_000;

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
		maxAge: ONE_YEAR_SECONDS,
		httpOnly: false,
		secure: url.protocol === 'https:'
	};

	let nextLocale = locals.locale;
	let nextRegion = locals.region;

	if ('lang' in payload) {
		if (payload.lang === null || payload.lang === '') {
			cookies.delete('ms_lang', { path: '/' });
		} else if (typeof payload.lang === 'string') {
			const normalized = normalizeLocaleTag(payload.lang);
			if (!normalized) {
				return json({ error: 'Unsupported language' }, { status: 400 });
			}
			cookies.set('ms_lang', normalized, cookieOptions);
			nextLocale = normalized;
		} else {
			return json({ error: 'Invalid language value' }, { status: 400 });
		}
	}

	if ('region' in payload) {
		if (payload.region === null || payload.region === '') {
			cookies.delete('ms_region', { path: '/' });
		} else if (typeof payload.region === 'string') {
			const normalized = normalizeRegionCode(payload.region);
			if (!normalized) {
				return json({ error: 'Invalid region code' }, { status: 400 });
			}
			cookies.set('ms_region', normalized, cookieOptions);
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
