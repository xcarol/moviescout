import { DEFAULT_LOCALE, type SupportedLocale } from './locales';
import type { ArbMessageKey } from './generated/keys';
import { WEB_MESSAGES, type WebMessageKey, type WebMessagesDictionary } from './web-messages';

import caES from './generated/messages/ca-ES.json';
import deDE from './generated/messages/de-DE.json';
import enUS from './generated/messages/en-US.json';
import es419 from './generated/messages/es-419.json';
import esES from './generated/messages/es-ES.json';
import euES from './generated/messages/eu-ES.json';
import frFR from './generated/messages/fr-FR.json';
import glES from './generated/messages/gl-ES.json';
import itIT from './generated/messages/it-IT.json';
import ptBR from './generated/messages/pt-BR.json';
import ptPT from './generated/messages/pt-PT.json';

export type ArbDictionary = Record<ArbMessageKey, string>;

const ARB_MESSAGES: Record<SupportedLocale, ArbDictionary> = {
	'ca-ES': caES as ArbDictionary,
	'de-DE': deDE as ArbDictionary,
	'en-US': enUS as ArbDictionary,
	'es-ES': esES as ArbDictionary,
	'es-419': es419 as ArbDictionary,
	'eu-ES': euES as ArbDictionary,
	'fr-FR': frFR as ArbDictionary,
	'gl-ES': glES as ArbDictionary,
	'it-IT': itIT as ArbDictionary,
	'pt-BR': ptBR as ArbDictionary,
	'pt-PT': ptPT as ArbDictionary
};

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
