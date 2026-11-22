<script lang="ts">
	import { TMDB_IMAGE_SIZE } from '$lib/constants/urls';
	import type { TitleSummary } from '$lib/types/tmdb';
	import PosterImage from '../core/PosterImage.svelte';

	interface Props {
		item: TitleSummary;
		subtitle?: string;
		priority?: 'high' | 'low' | 'normal';
		lazy?: boolean;
	}

	let { item, subtitle = '', priority = 'normal', lazy = true }: Props = $props();

	const year = $derived(item.releaseDate ? item.releaseDate.slice(0, 4) : '');
	const score = $derived(
		item.voteAverage > 0
			? item.voteAverage === 10
				? '10'
				: item.voteAverage.toFixed(1)
			: null
	);
	const href = $derived(`/${item.mediaType}/${item.id}`);
</script>

<a class="title-chip" {href}>
	<div class="chip-poster">
		<PosterImage
			path={item.posterPath}
			fallbackType={item.mediaType === 'movie' ? 'movie' : 'tvshow'}
			alt={item.title}
			size={TMDB_IMAGE_SIZE.w300}
			aspectRatio="2 / 3"
			radius="0px"
			{priority}
			{lazy}
		/>
		{#if score}
			<span class="score-pill" aria-label={`TMDB ${score}`}>
				&#9733; {score}
			</span>
		{/if}
	</div>

	<div class="chip-info">
		<p class="chip-title">{item.title}</p>
		{#if subtitle}
			<p class="chip-subtitle">{subtitle}</p>
		{:else if year}
			<p class="chip-subtitle">{year}</p>
		{/if}
	</div>
</a>

<style>
	.title-chip {
		flex: 0 0 148px;
		scroll-snap-align: start;
		display: flex;
		flex-direction: column;
		border-radius: var(--radius-chip);
		overflow: hidden;
		background-color: var(--color-surface-elevated);
		border: 1px solid var(--color-outline-subtle);
		transition: border-color 150ms ease, transform 150ms ease;
	}

	.title-chip:hover {
		border-color: var(--color-primary);
		transform: translateY(-2px);
	}

	.chip-poster {
		position: relative;
		width: 100%;
	}

	.score-pill {
		position: absolute;
		top: var(--space-xs);
		inset-inline-end: var(--space-xs);
		padding: var(--space-xxs) var(--space-xs);
		border-radius: var(--radius-xs);
		background-color: rgba(18, 18, 18, 0.85);
		color: var(--color-gold);
		font-size: var(--text-body-sm);
		font-weight: 700;
		font-variant-numeric: tabular-nums;
	}

	.chip-info {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxs);
		padding: var(--space-sm);
		flex: 1 1 auto;
	}

	.chip-title {
		font-size: var(--text-title-sm);
		font-weight: 600;
		line-height: 1.3;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
		line-clamp: 2;
		overflow: hidden;
	}

	.chip-subtitle {
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
		line-clamp: 2;
		overflow: hidden;
	}
</style>
