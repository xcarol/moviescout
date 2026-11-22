<script lang="ts">
	interface Props {
		text: string;
		maxLines?: number;
		moreLabel: string;
		lessLabel: string;
	}

	let { text, maxLines = 3, moreLabel, lessLabel }: Props = $props();

	let expanded = $state(false);
	let canExpand = $state(false);
	let paragraphEl: HTMLParagraphElement | undefined = $state();

	$effect(() => {
		void text;
		expanded = false;
		if (!paragraphEl) return;
		canExpand = paragraphEl.scrollHeight > paragraphEl.clientHeight + 2;
	});
</script>

{#if text.trim()}
	<div class="expandable-text">
		<p
			bind:this={paragraphEl}
			class="body"
			class:is-clamped={!expanded}
			style:--line-clamp={maxLines}
		>
			{text}
		</p>
		{#if canExpand || expanded}
			<button
				type="button"
				class="toggle-btn"
				aria-expanded={expanded}
				onclick={() => (expanded = !expanded)}
			>
				{expanded ? lessLabel : moreLabel}
			</button>
		{/if}
	</div>
{/if}

<style>
	.expandable-text {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: var(--space-xs);
	}

	.body {
		color: var(--color-text);
		font-size: var(--text-body-md);
		line-height: 1.6;
		white-space: pre-line;
	}

	.body.is-clamped {
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: var(--line-clamp, 3);
		line-clamp: var(--line-clamp, 3);
		overflow: hidden;
	}

	.toggle-btn {
		padding: var(--space-xs) 0;
		border: none;
		background: transparent;
		color: var(--color-primary);
		font-size: var(--text-body-sm);
		font-weight: 600;
		cursor: pointer;
	}

	.toggle-btn:hover {
		text-decoration: underline;
	}
</style>
