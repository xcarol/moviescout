<script lang="ts">
	import { TMDB_IMAGE_SIZE } from '$lib/constants/urls';
	import { t, type SupportedLocale } from '$lib/i18n';
	import type { WatchProviderItem, WatchProviders as WatchProvidersData } from '$lib/types/tmdb';
	import PosterImage from './PosterImage.svelte';

	interface Props {
		providers: WatchProvidersData;
		locale: SupportedLocale;
	}

	let { providers, locale }: Props = $props();

	interface ProviderGroup {
		label: string;
		items: WatchProviderItem[];
	}

	const groups = $derived.by((): ProviderGroup[] => {
		const candidates: ProviderGroup[] = [
			{ label: t(locale, 'freeProviders'), items: providers.free },
			{ label: t(locale, 'adsProviders'), items: providers.ads },
			{ label: t(locale, 'flatrateProviders'), items: providers.flatrate },
			{ label: t(locale, 'rentProviders'), items: providers.rent },
			{ label: t(locale, 'buyProviders'), items: providers.buy }
		];
		return candidates.filter((group) => group.items.length > 0);
	});
</script>

{#if groups.length > 0}
	<section class="providers-section">
		<div class="provider-groups">
			{#each groups as group (group.label)}
				<div class="provider-group">
					<h2 class="group-label">{group.label}</h2>
					<ul class="logo-row">
						{#each group.items as item (item.providerId)}
							<li class="logo-item" title={item.providerName}>
								<PosterImage
									path={item.logoPath}
									size={TMDB_IMAGE_SIZE.w185}
									fallbackType="provider"
									alt={item.providerName}
									aspectRatio="1 / 1"
									radius="var(--radius-sm)"
									width={36}
									height={36}
									lazy={true}
								/>
							</li>
						{/each}
					</ul>
				</div>
			{/each}
		</div>
	</section>
{/if}

<style>
	.provider-groups {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-xl);
	}

	.provider-group {
		display: flex;
		flex-direction: column;
		gap: var(--space-xs);
	}

	.group-label {
		font-size: var(--text-body-sm);
		font-weight: 700;
		color: var(--color-text);
	}

	.logo-row {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-xs);
		list-style: none;
		padding: 0;
		margin: 0;
	}

	.logo-item {
		width: 36px;
		height: 36px;
		border-radius: var(--radius-sm);
		overflow: hidden;
		border: 1px solid var(--color-border);
	}
</style>
