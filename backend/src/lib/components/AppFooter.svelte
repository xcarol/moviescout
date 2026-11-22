<script lang="ts">
	import { APP_NAME } from '$lib/constants/app';
	import {
		GITHUB_REPO_URL,
		GOOGLE_PLAY_URL,
		JUSTWATCH_WEB_URL,
		LOGO_ICON_ASSET,
		PRIVACY_POLICY_PATH,
		TERMS_OF_SERVICE_PATH,
		TMDB_LOGO_ASSET,
		TMDB_WEB_URL
	} from '$lib/constants/urls';
	import { t, tw, type SupportedLocale } from '$lib/i18n';

	interface Props {
		locale: SupportedLocale;
	}

	let { locale }: Props = $props();

	const tmdbParts = $derived.by(() => {
		const raw = t(locale, 'apiDisclaimer');
		const match = /\b(TMDb|TMDB)\b/.exec(raw);
		if (!match || match.index === undefined) {
			return { before: raw, label: '', after: '' };
		}
		return {
			before: raw.slice(0, match.index),
			label: match[1],
			after: raw.slice(match.index + match[1].length)
		};
	});

	const justwatchParts = $derived.by(() => {
		const raw = tw(locale, 'justwatchAttribution');
		const idx = raw.indexOf('JustWatch');
		if (idx === -1) {
			return { before: raw, label: '', after: '' };
		}
		return {
			before: raw.slice(0, idx),
			label: 'JustWatch',
			after: raw.slice(idx + 'JustWatch'.length)
		};
	});
</script>

<footer class="site-footer">
	<div class="content-container footer-inner">
		<div class="footer-top">
			<p class="copyright">
				<img src={LOGO_ICON_ASSET} alt="" width="24" height="24" class="brand-logo" />
				<span>&copy; {new Date().getFullYear()} {APP_NAME}</span>
			</p>

			<nav class="footer-links" aria-label="Footer">
				<a href={PRIVACY_POLICY_PATH}>{tw(locale, 'privacyPolicy')}</a>
				<a href={TERMS_OF_SERVICE_PATH}>{tw(locale, 'termsOfService')}</a>
				<a href={GITHUB_REPO_URL} target="_blank" rel="noopener noreferrer">
					GitHub
				</a>
				<a href={GOOGLE_PLAY_URL} target="_blank" rel="noopener noreferrer">
					Google Play
				</a>
			</nav>
		</div>

		<div class="footer-attribution">
			<a
				class="tmdb-link"
				href={TMDB_WEB_URL}
				target="_blank"
				rel="noopener noreferrer"
				aria-label="TMDB"
			>
				<img src={TMDB_LOGO_ASSET} alt="" width="20" height="20" class="tmdb-badge" />
			</a>
			<p class="attribution-copy">
				{tmdbParts.before}{#if tmdbParts.label}<a
						class="inline-link"
						href={TMDB_WEB_URL}
						target="_blank"
						rel="noopener noreferrer">{tmdbParts.label}</a
					>{/if}{tmdbParts.after}{' '}{justwatchParts.before}{#if justwatchParts.label}<a
						class="inline-link"
						href={JUSTWATCH_WEB_URL}
						target="_blank"
						rel="noopener noreferrer">{justwatchParts.label}</a
					>{/if}{justwatchParts.after}
			</p>
		</div>
	</div>
</footer>

<style>
	.site-footer {
		margin-block-start: var(--space-xxl);
		border-block-start: 1px solid var(--color-border);
		background-color: var(--color-surface-low);
		color: var(--color-text-muted);
		font-size: var(--text-body-sm);
	}

	.footer-inner {
		display: flex;
		flex-direction: column;
		gap: var(--space-md);
		padding-block: var(--space-xl);
	}

	.footer-top {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: var(--space-md);
		flex-wrap: wrap;
	}

	.copyright {
		display: inline-flex;
		align-items: center;
		gap: var(--space-sm);
		color: var(--color-text-subtle);
		white-space: nowrap;
	}

	.brand-logo {
		border-radius: var(--radius-xs);
		flex-shrink: 0;
	}

	.footer-links {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-md);
	}

	.footer-links a {
		color: var(--color-text);
		transition: color 150ms ease;
	}

	.footer-links a:hover {
		color: var(--color-primary);
		text-decoration: underline;
	}

	.footer-attribution {
		display: flex;
		align-items: center;
		gap: var(--space-sm);
		padding-block-start: var(--space-md);
		border-block-start: 1px solid var(--color-outline-subtle);
	}

	.tmdb-link {
		flex-shrink: 0;
		display: inline-flex;
	}

	.tmdb-badge {
		object-fit: contain;
	}

	.attribution-copy {
		margin: 0;
		line-height: 1.5;
	}

	.inline-link {
		color: var(--color-text);
		text-decoration: underline;
	}

	.inline-link:hover {
		color: var(--color-primary);
	}
</style>
