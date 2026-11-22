import { DEFAULT_LOCALE, type SupportedLocale } from './locales';
import {
	COUNTRIES,
	GENRES,
	LANGUAGES,
	PERSON_JOBS,
	STATUSES
} from './generated/registry';

type StringMap = Record<string, string>;

function translateCommaSeparated(
	raw: string,
	locale: SupportedLocale,
	selector: (loc: SupportedLocale) => StringMap | undefined
): string {
	if (!raw) return raw;
	const lookup = (token: string): string =>
		selector(locale)?.[token] || selector(DEFAULT_LOCALE)?.[token] || token;

	if (raw.includes(',')) {
		return raw
			.split(',')
			.map((part) => lookup(part.trim()))
			.join(', ');
	}
	return lookup(raw);
}

export function translateCountry(code: string, locale: SupportedLocale): string {
	if (!code) return code;
	const iso = code.toUpperCase();
	const localized = COUNTRIES[locale]?.[iso] || COUNTRIES[DEFAULT_LOCALE]?.[iso];
	if (localized) return localized;

	try {
		return new Intl.DisplayNames([locale], { type: 'region' }).of(iso) ?? iso;
	} catch {
		return iso;
	}
}

export function translateLanguage(code: string, locale: SupportedLocale): string {
	if (!code) return code;
	const normalized = code.toLowerCase();
	const localized =
		LANGUAGES[locale]?.[code] ||
		LANGUAGES[locale]?.[normalized] ||
		LANGUAGES[DEFAULT_LOCALE]?.[code] ||
		LANGUAGES[DEFAULT_LOCALE]?.[normalized];
	if (localized) return localized;

	try {
		return new Intl.DisplayNames([locale], { type: 'language' }).of(code) ?? code;
	} catch {
		return code;
	}
}

export function translateGenre(genreId: number, locale: SupportedLocale): string | undefined {
	const key = String(genreId);
	return GENRES[locale]?.[key] || GENRES[DEFAULT_LOCALE]?.[key];
}

export function translateDepartment(dept: string, locale: SupportedLocale): string {
	return translateCommaSeparated(dept, locale, (loc) => PERSON_JOBS[loc]?.departments);
}

export function translateJob(job: string, locale: SupportedLocale): string {
	return translateCommaSeparated(job, locale, (loc) => PERSON_JOBS[loc]?.jobs);
}

export function translateStatus(status: string, locale: SupportedLocale): string {
	if (!status) return status;
	return STATUSES[locale]?.[status] || STATUSES[DEFAULT_LOCALE]?.[status] || status;
}

export function getCountryOptions(
	locale: SupportedLocale
): Array<{ code: string; name: string }> {
	const table = COUNTRIES[locale] ?? COUNTRIES[DEFAULT_LOCALE];
	return Object.entries(table)
		.map(([code, name]) => ({ code, name }))
		.sort((a, b) => a.name.localeCompare(b.name, locale));
}
