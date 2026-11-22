export const SUPPORTED_LOCALES = [
	'ca-ES',
	'de-DE',
	'en-US',
	'es-ES',
	'es-419',
	'eu-ES',
	'fr-FR',
	'gl-ES',
	'it-IT',
	'pt-BR',
	'pt-PT'
] as const;

export type SupportedLocale = (typeof SUPPORTED_LOCALES)[number];

export const DEFAULT_LOCALE: SupportedLocale = 'en-US';
export const DEFAULT_REGION = 'US';

export const LOCALE_NATIVE_NAMES: Record<SupportedLocale, string> = {
	'ca-ES': 'Català',
	'de-DE': 'Deutsch',
	'en-US': 'English',
	'es-ES': 'Español (España)',
	'es-419': 'Español (Latinoamérica)',
	'eu-ES': 'Euskara',
	'fr-FR': 'Français',
	'gl-ES': 'Galego',
	'it-IT': 'Italiano',
	'pt-BR': 'Português (Brasil)',
	'pt-PT': 'Português (Portugal)'
};

export const LOCALE_OG_MAP: Record<SupportedLocale, string> = {
	'ca-ES': 'ca_ES',
	'de-DE': 'de_DE',
	'en-US': 'en_US',
	'es-ES': 'es_ES',
	'es-419': 'es_LA',
	'eu-ES': 'eu_ES',
	'fr-FR': 'fr_FR',
	'gl-ES': 'gl_ES',
	'it-IT': 'it_IT',
	'pt-BR': 'pt_BR',
	'pt-PT': 'pt_PT'
};

const EXACT_LOCALE_MAP = new Map<string, SupportedLocale>(
	SUPPORTED_LOCALES.map((locale) => [locale.toLowerCase(), locale])
);

const LATAM_SPANISH_TAGS = new Set([
	'es-419',
	'es-ar',
	'es-bo',
	'es-cl',
	'es-co',
	'es-cr',
	'es-cu',
	'es-do',
	'es-ec',
	'es-gt',
	'es-hn',
	'es-mx',
	'es-ni',
	'es-pa',
	'es-pe',
	'es-pr',
	'es-py',
	'es-sv',
	'es-us',
	'es-uy',
	'es-ve'
]);

const BASE_LANGUAGE_MAP: Record<string, SupportedLocale> = {
	ca: 'ca-ES',
	de: 'de-DE',
	en: 'en-US',
	es: 'es-ES',
	eu: 'eu-ES',
	fr: 'fr-FR',
	gl: 'gl-ES',
	it: 'it-IT',
	pt: 'pt-BR'
};

export function normalizeLocaleTag(raw?: string | null): SupportedLocale | null {
	if (!raw) return null;
	const cleaned = raw.trim().replace(/_/g, '-').toLowerCase();
	if (!cleaned || cleaned === '*') return null;

	const exact = EXACT_LOCALE_MAP.get(cleaned);
	if (exact) return exact;

	if (LATAM_SPANISH_TAGS.has(cleaned)) return 'es-419';
	if (cleaned === 'pt-pt') return 'pt-PT';
	if (cleaned === 'pt-br') return 'pt-BR';

	const base = cleaned.split('-')[0];
	return BASE_LANGUAGE_MAP[base] ?? null;
}

export function resolveLocale(
	acceptLanguage?: string | null,
	override?: string | null
): SupportedLocale {
	const overridden = normalizeLocaleTag(override);
	if (overridden) return overridden;

	if (!acceptLanguage) return DEFAULT_LOCALE;

	const candidates = acceptLanguage
		.split(',')
		.map((part, index) => {
			const [rawTag, ...params] = part.trim().split(';');
			let q = 1;
			for (const param of params) {
				const [k, v] = param.trim().split('=');
				if (k === 'q' && v !== undefined) {
					const parsed = Number.parseFloat(v);
					if (!Number.isNaN(parsed)) q = parsed;
				}
			}
			return { tag: rawTag, q, index };
		})
		.filter((item) => item.tag && item.q > 0)
		.sort((a, b) => (b.q !== a.q ? b.q - a.q : a.index - b.index));

	for (const candidate of candidates) {
		const matched = normalizeLocaleTag(candidate.tag);
		if (matched) return matched;
	}

	return DEFAULT_LOCALE;
}

const INVALID_REGION_CODES = new Set(['XX', 'ZZ', 'T1']);

export function normalizeRegionCode(raw?: string | null): string | null {
	if (!raw) return null;
	const upper = raw.trim().toUpperCase();
	if (!/^[A-Z]{2}$/.test(upper) || INVALID_REGION_CODES.has(upper)) {
		return null;
	}
	return upper;
}

export function regionFromLocale(locale: SupportedLocale): string {
	const [, region] = locale.split('-');
	return normalizeRegionCode(region) ?? DEFAULT_REGION;
}

export function resolveRegion(
	vercelCountry?: string | null,
	locale?: SupportedLocale,
	override?: string | null
): string {
	const overridden = normalizeRegionCode(override);
	if (overridden) return overridden;

	const headerCountry = normalizeRegionCode(vercelCountry);
	if (headerCountry) return headerCountry;

	return locale ? regionFromLocale(locale) : DEFAULT_REGION;
}
