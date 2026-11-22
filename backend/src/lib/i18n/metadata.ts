import { DEFAULT_LOCALE, type SupportedLocale } from './locales';

import countriesCaEs from './generated/metadata/countries_ca-ES.json';
import countriesDeDe from './generated/metadata/countries_de-DE.json';
import countriesEnUs from './generated/metadata/countries_en-US.json';
import countriesEs419 from './generated/metadata/countries_es-419.json';
import countriesEsEs from './generated/metadata/countries_es-ES.json';
import countriesEuEs from './generated/metadata/countries_eu-ES.json';
import countriesFrFr from './generated/metadata/countries_fr-FR.json';
import countriesGlEs from './generated/metadata/countries_gl-ES.json';
import countriesItIt from './generated/metadata/countries_it-IT.json';
import countriesPtBr from './generated/metadata/countries_pt-BR.json';
import countriesPtPt from './generated/metadata/countries_pt-PT.json';

import genresCaEs from './generated/metadata/genres_ca-ES.json';
import genresDeDe from './generated/metadata/genres_de-DE.json';
import genresEnUs from './generated/metadata/genres_en-US.json';
import genresEs419 from './generated/metadata/genres_es-419.json';
import genresEsEs from './generated/metadata/genres_es-ES.json';
import genresEuEs from './generated/metadata/genres_eu-ES.json';
import genresFrFr from './generated/metadata/genres_fr-FR.json';
import genresGlEs from './generated/metadata/genres_gl-ES.json';
import genresItIt from './generated/metadata/genres_it-IT.json';
import genresPtBr from './generated/metadata/genres_pt-BR.json';
import genresPtPt from './generated/metadata/genres_pt-PT.json';

import languagesCaEs from './generated/metadata/languages_ca-ES.json';
import languagesDeDe from './generated/metadata/languages_de-DE.json';
import languagesEnUs from './generated/metadata/languages_en-US.json';
import languagesEs419 from './generated/metadata/languages_es-419.json';
import languagesEsEs from './generated/metadata/languages_es-ES.json';
import languagesEuEs from './generated/metadata/languages_eu-ES.json';
import languagesFrFr from './generated/metadata/languages_fr-FR.json';
import languagesGlEs from './generated/metadata/languages_gl-ES.json';
import languagesItIt from './generated/metadata/languages_it-IT.json';
import languagesPtBr from './generated/metadata/languages_pt-BR.json';
import languagesPtPt from './generated/metadata/languages_pt-PT.json';

import personJobsCaEs from './generated/metadata/person_jobs_ca-ES.json';
import personJobsDeDe from './generated/metadata/person_jobs_de-DE.json';
import personJobsEnUs from './generated/metadata/person_jobs_en-US.json';
import personJobsEs419 from './generated/metadata/person_jobs_es-419.json';
import personJobsEsEs from './generated/metadata/person_jobs_es-ES.json';
import personJobsEuEs from './generated/metadata/person_jobs_eu-ES.json';
import personJobsFrFr from './generated/metadata/person_jobs_fr-FR.json';
import personJobsGlEs from './generated/metadata/person_jobs_gl-ES.json';
import personJobsItIt from './generated/metadata/person_jobs_it-IT.json';
import personJobsPtBr from './generated/metadata/person_jobs_pt-BR.json';
import personJobsPtPt from './generated/metadata/person_jobs_pt-PT.json';

import statusCaEs from './generated/metadata/status_ca-ES.json';
import statusDeDe from './generated/metadata/status_de-DE.json';
import statusEnUs from './generated/metadata/status_en-US.json';
import statusEs419 from './generated/metadata/status_es-419.json';
import statusEsEs from './generated/metadata/status_es-ES.json';
import statusEuEs from './generated/metadata/status_eu-ES.json';
import statusFrFr from './generated/metadata/status_fr-FR.json';
import statusGlEs from './generated/metadata/status_gl-ES.json';
import statusItIt from './generated/metadata/status_it-IT.json';
import statusPtBr from './generated/metadata/status_pt-BR.json';
import statusPtPt from './generated/metadata/status_pt-PT.json';

type StringMap = Record<string, string>;

const COUNTRIES: Record<SupportedLocale, StringMap> = {
	'ca-ES': countriesCaEs.countries,
	'de-DE': countriesDeDe.countries,
	'en-US': countriesEnUs.countries,
	'es-ES': countriesEsEs.countries,
	'es-419': countriesEs419.countries,
	'eu-ES': countriesEuEs.countries,
	'fr-FR': countriesFrFr.countries,
	'gl-ES': countriesGlEs.countries,
	'it-IT': countriesItIt.countries,
	'pt-BR': countriesPtBr.countries,
	'pt-PT': countriesPtPt.countries
};

const GENRES: Record<SupportedLocale, StringMap> = {
	'ca-ES': genresCaEs,
	'de-DE': genresDeDe,
	'en-US': genresEnUs,
	'es-ES': genresEsEs,
	'es-419': genresEs419,
	'eu-ES': genresEuEs,
	'fr-FR': genresFrFr,
	'gl-ES': genresGlEs,
	'it-IT': genresItIt,
	'pt-BR': genresPtBr,
	'pt-PT': genresPtPt
};

const LANGUAGES: Record<SupportedLocale, StringMap> = {
	'ca-ES': languagesCaEs.languages,
	'de-DE': languagesDeDe.languages,
	'en-US': languagesEnUs.languages,
	'es-ES': languagesEsEs.languages,
	'es-419': languagesEs419.languages,
	'eu-ES': languagesEuEs.languages,
	'fr-FR': languagesFrFr.languages,
	'gl-ES': languagesGlEs.languages,
	'it-IT': languagesItIt.languages,
	'pt-BR': languagesPtBr.languages,
	'pt-PT': languagesPtPt.languages
};

const PERSON_JOBS: Record<
	SupportedLocale,
	{ departments: StringMap; jobs: StringMap }
> = {
	'ca-ES': personJobsCaEs,
	'de-DE': personJobsDeDe,
	'en-US': personJobsEnUs,
	'es-ES': personJobsEsEs,
	'es-419': personJobsEs419,
	'eu-ES': personJobsEuEs,
	'fr-FR': personJobsFrFr,
	'gl-ES': personJobsGlEs,
	'it-IT': personJobsItIt,
	'pt-BR': personJobsPtBr,
	'pt-PT': personJobsPtPt
};

const STATUSES: Record<SupportedLocale, StringMap> = {
	'ca-ES': statusCaEs,
	'de-DE': statusDeDe,
	'en-US': statusEnUs,
	'es-ES': statusEsEs,
	'es-419': statusEs419,
	'eu-ES': statusEuEs,
	'fr-FR': statusFrFr,
	'gl-ES': statusGlEs,
	'it-IT': statusItIt,
	'pt-BR': statusPtBr,
	'pt-PT': statusPtPt
};

function translateCommaSeparated(
	raw: string,
	locale: SupportedLocale,
	selector: (loc: SupportedLocale) => StringMap
): string {
	if (!raw) return raw;
	const lookup = (token: string): string =>
		selector(locale)[token] || selector(DEFAULT_LOCALE)[token] || token;

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
	return translateCommaSeparated(dept, locale, (loc) => PERSON_JOBS[loc].departments);
}

export function translateJob(job: string, locale: SupportedLocale): string {
	return translateCommaSeparated(job, locale, (loc) => PERSON_JOBS[loc].jobs);
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
