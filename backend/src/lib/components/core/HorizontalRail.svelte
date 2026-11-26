<script lang="ts">
	import type { Snippet } from 'svelte';

	interface Props {
		title: string;
		children: Snippet;
		action?: Snippet;
	}

	let { title, children, action }: Props = $props();
</script>

<section class="rail-section">
	<div class="rail-header">
		<h2 class="rail-title">{title}</h2>
		{#if action}
			{@render action()}
		{/if}
	</div>

	<div class="rail-track">
		{@render children()}
	</div>
</section>

<style>
	.rail-section {
		display: flex;
		flex-direction: column;
		gap: var(--space-md);
	}

	.rail-header {
		display: flex;
		align-items: baseline;
		justify-content: space-between;
		gap: var(--space-md);
	}

	.rail-title {
		font-size: var(--text-title-md);
		font-weight: 700;
	}

	.rail-track {
		display: flex;
		gap: var(--space-md);
		overflow-x: auto;
		scroll-snap-type: x proximity;
		overscroll-behavior-x: contain;
		padding-block: var(--space-xs);
		scrollbar-color: var(--color-scrollbar-thumb) transparent;
	}
</style>
