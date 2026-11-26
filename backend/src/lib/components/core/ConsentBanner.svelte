<script lang="ts">
	import { PRIVACY_POLICY_PATH } from '$lib/constants/urls';
	import { tw, type SupportedLocale } from '$lib/i18n';
	import {
		acceptAnalytics,
		declineAnalytics,
		isConsentBannerOpen
	} from '$lib/utils/analytics.svelte';

	interface Props {
		locale: SupportedLocale;
	}

	let { locale }: Props = $props();
</script>

{#if isConsentBannerOpen()}
	<aside class="consent-wrap" aria-labelledby="consent-message">
		<div class="consent-bar">
			<p id="consent-message" class="consent-text">
				{tw(locale, 'analyticsConsentMessage')}{' '}
				<a class="consent-link" href={PRIVACY_POLICY_PATH}>{tw(locale, 'privacyPolicy')}</a>
			</p>

			<div class="consent-actions">
				<button type="button" class="btn-decline" onclick={declineAnalytics}>
					{tw(locale, 'analyticsConsentDecline')}
				</button>
				<button type="button" class="btn-accept" onclick={acceptAnalytics}>
					{tw(locale, 'analyticsConsentAccept')}
				</button>
			</div>
		</div>
	</aside>
{/if}

<style>
	.consent-wrap {
		position: fixed;
		inset-block-end: var(--space-md);
		inset-inline: var(--space-md);
		z-index: 50;
		pointer-events: none;
	}

	.consent-bar {
		pointer-events: auto;
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-md);
		max-width: var(--max-content-width);
		margin-inline: auto;
		padding: var(--space-md) var(--space-lg);
		border-radius: var(--radius-chip);
		background-color: var(--color-surface-elevated);
		border: 1px solid var(--color-border);
		box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
	}

	.consent-text {
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
		line-height: 1.45;
	}

	.consent-link {
		color: var(--color-text);
		text-decoration: underline;
	}

	.consent-link:hover {
		color: var(--color-primary);
	}

	.consent-actions {
		display: flex;
		align-items: center;
		gap: var(--space-sm);
		flex-shrink: 0;
	}

	.btn-decline,
	.btn-accept {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		min-height: 36px;
		padding: var(--space-xs) var(--space-md);
		border-radius: var(--radius-sm);
		font-size: var(--text-body-sm);
		font-weight: 600;
		white-space: nowrap;
		cursor: pointer;
	}

	.btn-decline {
		background-color: transparent;
		border: 1px solid var(--color-outline);
		color: var(--color-text);
	}

	.btn-decline:hover {
		border-color: var(--color-primary);
	}

	.btn-accept {
		background-color: var(--color-primary);
		border: 1px solid var(--color-primary);
		color: var(--color-on-primary);
		font-weight: 700;
	}

	.btn-accept:hover {
		background-color: var(--color-primary-hover);
		border-color: var(--color-primary-hover);
	}

	@media (max-width: 600px) {
		.consent-wrap {
			inset-block-end: var(--space-sm);
			inset-inline: var(--space-sm);
		}

		.consent-bar {
			flex-direction: column;
			align-items: stretch;
			gap: var(--space-sm);
			padding: var(--space-md);
		}

		.consent-actions {
			justify-content: flex-end;
		}
	}
</style>
