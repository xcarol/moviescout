import type { SupportedLocale } from '$lib/i18n';

export function formatDate(dateString: string, locale: SupportedLocale): string {
	const trimmed = dateString.trim();
	if (!trimmed) return '';

	const dateMatch = /^(\d{4})-(\d{2})-(\d{2})$/.exec(trimmed);
	const timestamp = dateMatch
		? Date.UTC(Number(dateMatch[1]), Number(dateMatch[2]) - 1, Number(dateMatch[3]))
		: Date.parse(trimmed);

	if (Number.isNaN(timestamp)) return dateString;

	return new Intl.DateTimeFormat(locale, {
		year: 'numeric',
		month: 'short',
		day: 'numeric',
		timeZone: 'UTC'
	}).format(timestamp);
}
