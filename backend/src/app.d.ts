import type { SupportedLocale } from '$lib/i18n';

declare global {
	namespace App {
		interface Locals {
			locale: SupportedLocale;
			region: string;
			hasCustomPrefs: boolean;
		}
	}
}

export {};
