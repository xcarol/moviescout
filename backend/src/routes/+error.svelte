<script lang="ts">
	import { page } from '$app/state';
	import SeoHead from '$lib/components/SeoHead.svelte';
	import { APP_NAME } from '$lib/constants/app';
	import { ERROR_NETWORK_ASSET } from '$lib/constants/urls';
	import { DEFAULT_LOCALE, t, tw, type SupportedLocale } from '$lib/i18n';

	const locale: SupportedLocale = $derived(
		(page.data?.locale as SupportedLocale | undefined) ?? DEFAULT_LOCALE
	);
	const isNotFound = $derived(page.status === 404);
	const heading = $derived(
		isNotFound ? tw(locale, 'notFoundTitle') : t(locale, 'errorMessageGeneric')
	);
	const message = $derived(
		isNotFound
			? tw(locale, 'notFoundMessage')
			: page.error?.message || t(locale, 'errorMessageGeneric')
	);
</script>

<SeoHead
	title={`${page.status} — ${APP_NAME}`}
	description={message}
	canonicalPath={page.url.pathname}
	{locale}
	noindex={true}
/>

<section class="error-view content-container" aria-labelledby="error-heading">
	<img src={ERROR_NETWORK_ASSET} alt="" width="180" height="180" class="error-art" />
	<p class="status-code">{page.status}</p>
	<h1 id="error-heading" class="error-title">{heading}</h1>
	<p class="error-message">{message}</p>

	<div class="error-actions">
		{#if !isNotFound}
			<button type="button" class="btn-secondary" onclick={() => location.reload()}>
				{tw(locale, 'retry')}
			</button>
		{/if}
		<a class="btn-primary" href="/">{tw(locale, 'backToHome')}</a>
	</div>
</section>

<style>
	.error-view {
		display: flex;
		flex-direction: column;
		align-items: center;
		text-align: center;
		gap: var(--space-md);
		padding-block: var(--space-xxxl);
	}

	.error-art {
		width: 160px;
		height: auto;
		object-fit: contain;
	}

	.status-code {
		font-size: var(--text-title-sm);
		font-weight: 700;
		color: var(--color-primary);
		letter-spacing: 0.08em;
	}

	.error-title {
		font-size: clamp(1.25rem, 2.5vw, 1.75rem);
		font-weight: 800;
	}

	.error-message {
		max-width: 480px;
		color: var(--color-text-muted);
		font-size: var(--text-body-md);
	}

	.error-actions {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: var(--space-md);
		margin-block-start: var(--space-sm);
	}

	.btn-primary,
	.btn-secondary {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		min-height: 40px;
		padding: var(--space-sm) var(--space-xl);
		border-radius: var(--radius-sm);
		font-weight: 700;
		font-size: var(--text-body-sm);
		cursor: pointer;
	}

	.btn-primary {
		background-color: var(--color-primary);
		color: var(--color-on-primary);
	}

	.btn-primary:hover {
		background-color: var(--color-primary-hover);
	}

	.btn-secondary {
		border: 1px solid var(--color-outline);
		background-color: var(--color-surface);
		color: var(--color-text);
	}

	.btn-secondary:hover {
		border-color: var(--color-primary);
	}
</style>
