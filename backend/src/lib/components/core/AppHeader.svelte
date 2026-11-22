<script lang="ts">
	import { invalidateAll } from '$app/navigation';
	import { APP_NAME } from '$lib/constants/app';
	import { LOGO_ICON_ASSET } from '$lib/constants/urls';
	import {
		getCountryOptions,
		LOCALE_NATIVE_NAMES,
		SUPPORTED_LOCALES,
		tw,
		type SupportedLocale
	} from '$lib/i18n';

	interface Props {
		locale: SupportedLocale;
		region: string;
	}

	let { locale, region }: Props = $props();

	let saving = $state(false);
	const countryOptions = $derived(getCountryOptions(locale));

	async function updatePreference(patch: { lang?: string; region?: string }) {
		if (saving) return;
		saving = true;
		try {
			const response = await fetch('/api/preferences', {
				method: 'POST',
				headers: { 'content-type': 'application/json' },
				body: JSON.stringify(patch)
			});
			if (response.ok) {
				await invalidateAll();
			}
		} finally {
			saving = false;
		}
	}
</script>

<a class="skip-link" href="#main-content">{tw(locale, 'skipToContent')}</a>

<header class="site-header">
	<div class="content-container header-inner">
		<a class="brand" href="/">
			<img src={LOGO_ICON_ASSET} alt="" width="28" height="28" class="brand-logo" />
			<span class="brand-name">{APP_NAME}</span>
		</a>

		<div class="header-controls">
			<label class="select-wrap">
				<span class="visually-hidden">{tw(locale, 'languageLabel')}</span>
				<select
					aria-label={tw(locale, 'languageLabel')}
					value={locale}
					disabled={saving}
					onchange={(e) => updatePreference({ lang: e.currentTarget.value })}
				>
					{#each SUPPORTED_LOCALES as code (code)}
						<option value={code}>{LOCALE_NATIVE_NAMES[code]}</option>
					{/each}
				</select>
			</label>

			<label class="select-wrap">
				<span class="visually-hidden">{tw(locale, 'regionLabel')}</span>
				<select
					aria-label={tw(locale, 'regionLabel')}
					value={region}
					disabled={saving}
					onchange={(e) => updatePreference({ region: e.currentTarget.value })}
				>
					{#each countryOptions as option (option.code)}
						<option value={option.code}>{option.code} · {option.name}</option>
					{/each}
				</select>
			</label>
		</div>
	</div>
</header>

<style>
	.site-header {
		position: sticky;
		top: 0;
		z-index: 40;
		background-color: var(--color-bg);
		border-block-end: 1px solid var(--color-border);
	}

	.header-inner {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-md);
		min-height: 56px;
		padding-block: var(--space-sm);
		flex-wrap: wrap;
	}

	.brand {
		display: inline-flex;
		align-items: center;
		gap: var(--space-sm);
		font-weight: 700;
		font-size: var(--text-title-lg);
		letter-spacing: -0.01em;
		color: var(--color-text);
	}

	.brand-logo {
		border-radius: var(--radius-xs);
		flex-shrink: 0;
	}

	.header-controls {
		display: flex;
		align-items: center;
		gap: var(--space-sm);
		flex-wrap: wrap;
	}

	.select-wrap {
		display: inline-flex;
		align-items: center;
	}

	select {
		min-height: 36px;
		max-width: 170px;
		padding: var(--space-xs) var(--space-sm);
		border-radius: var(--radius-sm);
		border: 1px solid var(--color-outline);
		background-color: var(--color-surface);
		color: var(--color-text);
		font-size: var(--text-body-sm);
		cursor: pointer;
	}

	select:hover:not(:disabled) {
		border-color: var(--color-primary);
	}

	select:disabled {
		opacity: 0.6;
		cursor: wait;
	}

	@media (max-width: 600px) {
		select {
			max-width: 140px;
		}
	}
</style>
