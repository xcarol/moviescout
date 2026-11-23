<script lang="ts">
	import { GOOGLE_PLAY_URL, LOGO_ICON_ASSET } from '$lib/constants/urls';
	import { tw, type SupportedLocale } from '$lib/i18n';
	import GooglePlayIcon from './GooglePlayIcon.svelte';

	interface Props {
		locale: SupportedLocale;
	}

	let { locale }: Props = $props();
</script>

<aside class="promo-banner" aria-label={tw(locale, 'appBannerTitle')}>
	<div class="promo-info">
		<img src={LOGO_ICON_ASSET} alt="" width="40" height="40" class="promo-icon" />
		<div class="promo-copy">
			<p class="promo-title">{tw(locale, 'appBannerTitle')}</p>
			<p class="promo-subtitle">{tw(locale, 'appBannerSubtitle')}</p>
		</div>
	</div>

	<a
		class="promo-cta"
		href={GOOGLE_PLAY_URL}
		target="_blank"
		rel="noopener noreferrer"
	>
		<GooglePlayIcon size={18} />
		<span>{tw(locale, 'getItOnGooglePlay')}</span>
	</a>
</aside>

<style>
	.promo-banner {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-md);
		flex-wrap: wrap;
		padding: var(--space-lg);
		border-radius: var(--radius-chip);
		background-color: var(--color-surface);
		border: 1px solid var(--color-border);
	}

	.promo-info {
		display: flex;
		align-items: center;
		gap: var(--space-md);
		min-width: 0;
		flex: 1 1 260px;
	}

	.promo-icon {
		border-radius: var(--radius-sm);
		flex-shrink: 0;
	}

	.promo-copy {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxs);
	}

	.promo-title {
		font-weight: 700;
		font-size: var(--text-title-sm);
		color: var(--color-text);
	}

	.promo-subtitle {
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
	}

	.promo-cta {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: var(--space-sm);
		min-height: 40px;
		padding: var(--space-sm) var(--space-lg);
		border-radius: var(--radius-sm);
		background-color: var(--color-primary);
		color: var(--color-on-primary);
		font-weight: 700;
		font-size: var(--text-body-sm);
		white-space: nowrap;
	}

	.promo-cta:hover {
		background-color: var(--color-primary-hover);
	}
</style>
