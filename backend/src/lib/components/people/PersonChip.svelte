<script lang="ts">
	import { TMDB_IMAGE_SIZE } from '$lib/constants/urls';
	import type { PersonSummary } from '$lib/types/tmdb';
	import PosterImage from '../core/PosterImage.svelte';

	interface Props {
		person: PersonSummary;
		roleText?: string;
		lazy?: boolean;
	}

	let { person, roleText, lazy = true }: Props = $props();

	const resolvedRole = $derived(roleText ?? person.role);
</script>

<a class="person-chip" href={`/person/${person.id}`}>
	<PosterImage
		path={person.profilePath}
		fallbackType="person"
		alt={person.name}
		size={TMDB_IMAGE_SIZE.w185}
		aspectRatio="2 / 3"
		radius="0px"
		{lazy}
	/>

	<div class="chip-info">
		<p class="chip-name">{person.name}</p>
		{#if resolvedRole}
			<p class="chip-role">{resolvedRole}</p>
		{/if}
	</div>
</a>

<style>
	.person-chip {
		flex: 0 0 132px;
		scroll-snap-align: start;
		display: flex;
		flex-direction: column;
		border-radius: var(--radius-chip);
		overflow: hidden;
		background-color: var(--color-surface-elevated);
		border: 1px solid var(--color-outline-subtle);
		transition: border-color 150ms ease, transform 150ms ease;
	}

	.person-chip:hover {
		border-color: var(--color-primary);
		transform: translateY(-2px);
	}

	.chip-info {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxs);
		padding: var(--space-sm);
	}

	.chip-name {
		font-size: var(--text-title-sm);
		font-weight: 600;
		line-height: 1.3;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
		line-clamp: 2;
		overflow: hidden;
	}

	.chip-role {
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
		line-clamp: 2;
		overflow: hidden;
	}
</style>
