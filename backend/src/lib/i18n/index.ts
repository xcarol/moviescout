import { DEFAULT_LOCALE, type SupportedLocale } from './locales';
import type { ArbMessageKey } from './generated/keys';
import { ARB_MESSAGES } from './generated/registry';
import { WEB_MESSAGES, type WebMessageKey, type WebMessagesDictionary } from './web-messages';

export type ArbDictionary = Record<ArbMessageKey, string>;

export function interpolate(
	template: string,
	params?: Record<string, string | number>
): string {
	if (!params) return template;
	return template.replace(/\{(\w+)\}/g, (match, key) =>
		key in params ? String(params[key]) : match
	);
}

export function getMessages(locale: SupportedLocale): ArbDictionary {
	return ARB_MESSAGES[locale] ?? ARB_MESSAGES[DEFAULT_LOCALE];
}

export function getWebMessages(locale: SupportedLocale): WebMessagesDictionary {
	return WEB_MESSAGES[locale] ?? WEB_MESSAGES[DEFAULT_LOCALE];
}

export function t(
	locale: SupportedLocale,
	key: ArbMessageKey,
	params?: Record<string, string | number>
): string {
	const template =
		ARB_MESSAGES[locale]?.[key] ?? ARB_MESSAGES[DEFAULT_LOCALE][key] ?? key;
	return interpolate(template, params);
}

export function tw(
	locale: SupportedLocale,
	key: WebMessageKey,
	params?: Record<string, string | number>
): string {
	const template =
		WEB_MESSAGES[locale]?.[key] ?? WEB_MESSAGES[DEFAULT_LOCALE][key] ?? key;
	return interpolate(template, params);
}

export * from './locales';
export * from './metadata';
export * from './generated/keys';
export { WEB_MESSAGES, type WebMessageKey, type WebMessagesDictionary } from './web-messages';
