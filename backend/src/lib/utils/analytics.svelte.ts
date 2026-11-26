import { browser } from '$app/environment';
import { env } from '$env/dynamic/public';

export type ConsentStatus = 'unset' | 'granted' | 'denied';

const CONSENT_STORAGE_KEY = 'ms_analytics_consent';
const GTAG_SCRIPT_ID = 'ga-gtag-script';

declare global {
	interface Window {
		dataLayer?: unknown[][];
		gtag?: (...args: unknown[]) => void;
	}
}

let consent = $state<ConsentStatus>('unset');
let bannerOpen = $state(false);
let scriptInjected = false;

function getMeasurementId(): string {
	return env.PUBLIC_GA_MEASUREMENT_ID?.trim() ?? '';
}

export function hasAnalyticsConfigured(): boolean {
	return getMeasurementId().length > 0;
}

export function getAnalyticsConsent(): ConsentStatus {
	return consent;
}

export function isConsentBannerOpen(): boolean {
	return bannerOpen;
}

function readStoredConsent(): ConsentStatus {
	try {
		const stored = localStorage.getItem(CONSENT_STORAGE_KEY);
		if (stored === 'granted' || stored === 'denied') return stored;
	} catch {
		// Private browsing or blocked storage keeps default unset state.
	}
	return 'unset';
}

function writeStoredConsent(status: 'granted' | 'denied'): void {
	try {
		localStorage.setItem(CONSENT_STORAGE_KEY, status);
	} catch {
		// Ignore storage write errors in restricted browser contexts.
	}
}

function clearAnalyticsCookies(): void {
	try {
		const names = document.cookie
			.split(';')
			.map((part) => part.split('=')[0]?.trim())
			.filter((name): name is string => Boolean(name && name.startsWith('_ga')));

		const hostParts = window.location.hostname.split('.');
		const domainCandidates = [''];
		if (hostParts.length >= 2) {
			domainCandidates.push(`; domain=.${hostParts.slice(-2).join('.')}`);
			domainCandidates.push(`; domain=${window.location.hostname}`);
		}

		for (const name of names) {
			for (const domainAttr of domainCandidates) {
				document.cookie = `${name}=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/${domainAttr}`;
			}
		}
	} catch {
		// Ignore cookie cleanup errors.
	}
}

function ensureGtagInitialized(measurementId: string): void {
	if (!browser || !measurementId) return;

	window.dataLayer = window.dataLayer || [];
	if (!window.gtag) {
		window.gtag = (...args: unknown[]) => {
			window.dataLayer?.push(args);
		};
		window.gtag('consent', 'default', {
			analytics_storage: 'granted',
			ad_storage: 'denied',
			ad_user_data: 'denied',
			ad_personalization: 'denied'
		});
		window.gtag('js', new Date());
		window.gtag('config', measurementId, {
			send_page_view: false
		});
	} else {
		window.gtag('consent', 'update', {
			analytics_storage: 'granted',
			ad_storage: 'denied',
			ad_user_data: 'denied',
			ad_personalization: 'denied'
		});
	}

	if (!scriptInjected && !document.getElementById(GTAG_SCRIPT_ID)) {
		scriptInjected = true;
		const script = document.createElement('script');
		script.id = GTAG_SCRIPT_ID;
		script.async = true;
		script.src = `https://www.googletagmanager.com/gtag/js?id=${encodeURIComponent(measurementId)}`;
		document.head.appendChild(script);
	}
}

export function trackPageView(url: URL | string, title: string): void {
	if (!browser) return;
	const measurementId = getMeasurementId();
	if (!measurementId || consent !== 'granted' || !window.gtag) return;

	const parsed = typeof url === 'string' ? new URL(url, window.location.origin) : url;
	window.gtag('event', 'page_view', {
		send_to: measurementId,
		page_location: parsed.href,
		page_path: `${parsed.pathname}${parsed.search}`,
		page_title: title
	});
}

export function initAnalytics(): void {
	if (!browser) return;
	const measurementId = getMeasurementId();
	if (!measurementId) {
		consent = 'denied';
		bannerOpen = false;
		return;
	}

	consent = readStoredConsent();
	if (consent === 'granted') {
		ensureGtagInitialized(measurementId);
		trackPageView(window.location.href, document.title);
		bannerOpen = false;
	} else {
		bannerOpen = consent === 'unset';
	}
}

export function acceptAnalytics(): void {
	if (!browser) return;
	const measurementId = getMeasurementId();
	consent = 'granted';
	bannerOpen = false;
	writeStoredConsent('granted');

	if (measurementId) {
		ensureGtagInitialized(measurementId);
		trackPageView(window.location.href, document.title);
	}
}

export function declineAnalytics(): void {
	if (!browser) return;
	consent = 'denied';
	bannerOpen = false;
	writeStoredConsent('denied');

	if (window.gtag) {
		window.gtag('consent', 'update', {
			analytics_storage: 'denied',
			ad_storage: 'denied',
			ad_user_data: 'denied',
			ad_personalization: 'denied'
		});
	}
	clearAnalyticsCookies();
}

export function openConsentBanner(): void {
	if (!hasAnalyticsConfigured()) return;
	bannerOpen = true;
}
