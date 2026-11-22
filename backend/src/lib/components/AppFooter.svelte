<script lang="ts">
	import { APP_NAME } from '$lib/constants/app';
	import {
		GITHUB_REPO_URL,
		GOOGLE_PLAY_URL,
		PRIVACY_POLICY_PATH,
		TERMS_OF_SERVICE_PATH,
		TMDB_LOGO_ASSET
	} from '$lib/constants/urls';
	import { t, tw, type SupportedLocale } from '$lib/i18n';

	interface Props {
		locale: SupportedLocale;
	}

	let { locale }: Props = $props();
</script>

<footer class="site-footer">
	<div class="content-container footer-inner">
		<div class="footer-top">
			<div class="footer-attribution">
				<img src={TMDB_LOGO_ASSET} alt="TMDB" width="24" height="24" class="tmdb-badge" />
				<div class="attribution-copy">
					<p>{t(locale, 'apiDisclaimer')}</p>
					<p>{tw(locale, 'justwatchAttribution')}</p>
				</div>
			</div>

			<nav class="footer-links" aria-label="Footer">
				<a href={PRIVACY_POLICY_PATH}>{tw(locale, 'privacyPolicy')}</a>
				<a href={TERMS_OF_SERVICE_PATH}>{tw(locale, 'termsOfService')}</a>
				<a href={GITHUB_REPO_URL} target="_blank" rel="noopener noreferrer">
					GitHub
				</a>
				<a
					href={GOOGLE_PLAY_URL}
					target="_blank"
					rel="noopener noreferrer"
				>
					Google Play
				</a>
			</nav>
		</div>

		<p class="copyright">&copy; {new Date().getFullYear()} {APP_NAME}</p>
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
		align-items: flex-start;
		gap: var(--space-lg);
		flex-wrap: wrap;
	}

	.footer-attribution {
		display: flex;
		align-items: flex-start;
		gap: var(--space-sm);
		max-width: 480px;
	}

	.tmdb-badge {
		flex-shrink: 0;
		margin-block-start: var(--space-xxs);
		object-fit: contain;
	}

	.attribution-copy {
		display: flex;
		flex-direction: column;
		gap: var(--space-xs);
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

	.copyright {
		color: var(--color-text-subtle);
	}
</style>
