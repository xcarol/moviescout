<script lang="ts">
	import { TMDB_LOGO_ASSET } from '$lib/constants/urls';
	import type { OmdbRating } from '$lib/types/tmdb';

	interface Props {
		tmdbVoteAverage: number;
		tmdbVoteCount?: number;
		omdbRatings?: OmdbRating[];
		isUnreleased?: boolean;
		notReleasedText?: string;
	}

	let {
		tmdbVoteAverage,
		tmdbVoteCount = 0,
		omdbRatings = [],
		isUnreleased = false,
		notReleasedText = ''
	}: Props = $props();

	const formattedTmdb = $derived(
		tmdbVoteAverage > 0
			? tmdbVoteAverage === 10
				? '10'
				: tmdbVoteAverage.toFixed(1)
			: null
	);
</script>

{#if isUnreleased && notReleasedText}
	<p class="unreleased">{notReleasedText}</p>
{:else if formattedTmdb || omdbRatings.length > 0}
	<div class="rating-list">
		{#if formattedTmdb}
			<div
				class="rating-badge"
				title={tmdbVoteCount > 0 ? `TMDB (${tmdbVoteCount})` : 'The Movie Database'}
			>
				<img src={TMDB_LOGO_ASSET} alt="TMDB" width="16" height="16" />
				<span class="rating-score">{formattedTmdb}</span>
			</div>
		{/if}

		{#each omdbRatings as rating (rating.source)}
			<div class="rating-badge" title={`${rating.source}: ${rating.rawValue}`}>
				{#if rating.logoAsset}
					<img src={rating.logoAsset} alt={rating.source} width="16" height="16" />
				{:else}
					<span class="rating-source">{rating.source}</span>
				{/if}
				<span class="rating-score">{rating.normalizedValue}</span>
			</div>
		{/each}
	</div>
{/if}

<style>
	.unreleased {
		color: var(--color-text-muted);
		font-size: var(--text-body-sm);
		font-style: italic;
	}

	.rating-list {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-sm);
		align-items: center;
	}

	.rating-badge {
		display: inline-flex;
		align-items: center;
		gap: var(--space-xs);
		padding: var(--space-xs) var(--space-sm);
		border-radius: var(--radius-sm);
		background-color: var(--color-surface-elevated);
		border: 1px solid var(--color-border);
	}

	.rating-badge img {
		height: 16px;
		width: auto;
		object-fit: contain;
	}

	.rating-source {
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
	}

	.rating-score {
		font-weight: 700;
		font-size: var(--text-body-sm);
		color: var(--color-on-secondary);
		font-variant-numeric: tabular-nums;
	}
</style>
