import type { SupportedLocale } from '$lib/i18n';

function parseUtcDate(dateString: string): Date | null {
	const trimmed = dateString.trim();
	if (!trimmed) return null;

	const dateMatch = /^(\d{4})-(\d{2})-(\d{2})$/.exec(trimmed);
	const timestamp = dateMatch
		? Date.UTC(Number(dateMatch[1]), Number(dateMatch[2]) - 1, Number(dateMatch[3]))
		: Date.parse(trimmed);

	return Number.isNaN(timestamp) ? null : new Date(timestamp);
}

export function formatDate(dateString: string, locale: SupportedLocale): string {
	const trimmed = dateString.trim();
	if (!trimmed) return '';

	const date = parseUtcDate(trimmed);
	if (!date) return dateString;

	return new Intl.DateTimeFormat(locale, {
		year: 'numeric',
		month: 'short',
		day: 'numeric',
		timeZone: 'UTC'
	}).format(date);
}

export function calculateAge(birthDateString: string, deathDateString = ''): number | null {
	const birthDate = parseUtcDate(birthDateString);
	if (!birthDate) return null;

	const endDate = deathDateString.trim() ? parseUtcDate(deathDateString) : new Date();
	if (!endDate) return null;

	let age = endDate.getUTCFullYear() - birthDate.getUTCFullYear();
	const monthDiff = endDate.getUTCMonth() - birthDate.getUTCMonth();
	if (monthDiff < 0 || (monthDiff === 0 && endDate.getUTCDate() < birthDate.getUTCDate())) {
		age--;
	}

	return age >= 0 ? age : null;
}
