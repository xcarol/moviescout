<script lang="ts">
	import { t, type SupportedLocale } from '$lib/i18n';
	import type { MediaType, PersonSummary } from '$lib/types/tmdb';
	import { getCreators, getDirectors, getWriters } from '$lib/utils/credits';
	import ClickableNames from './ClickableNames.svelte';

	interface Props {
		crew: PersonSummary[];
		mediaType: MediaType;
		locale: SupportedLocale;
	}

	let { crew, mediaType, locale }: Props = $props();

	const isMovie = $derived(mediaType === 'movie');
	const primaryCreators = $derived(isMovie ? getDirectors(crew) : getCreators(crew));
	const writers = $derived(getWriters(crew));
</script>

{#if primaryCreators.length > 0 || writers.length > 0}
	<section class="credits-info">
		{#if primaryCreators.length > 0}
			<div class="meta-field">
				<span class="field-label">{isMovie ? t(locale, 'director') : t(locale, 'creator')}</span>
				<ClickableNames people={primaryCreators} {locale} />
			</div>
		{/if}

		{#if writers.length > 0}
			<div class="meta-field">
				<span class="field-label">{t(locale, 'writer')}</span>
				<ClickableNames people={writers} {locale} />
			</div>
		{/if}
	</section>
{/if}

<style>
	.credits-info {
		display: flex;
		flex-direction: column;
		gap: var(--space-md);
	}

	.meta-field {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxs);
	}

	.field-label {
		font-size: var(--text-body-sm);
		color: var(--color-text-subtle);
	}
</style>
