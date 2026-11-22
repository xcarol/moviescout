<script lang="ts">
	import { untrack } from 'svelte';

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
	let lastText = '';

	$effect(() => {
		if (text !== lastText) {
			lastText = text;
			expanded = false;
		}
	});

	$effect(() => {
		const el = paragraphEl;
		void text;
		void maxLines;
		if (!el) return;

		const measure = () => {
			if (!untrack(() => expanded)) {
				canExpand = el.scrollHeight > el.clientHeight + 2;
			}
		};

		measure();
		const observer = new ResizeObserver(measure);
		observer.observe(el);

		return () => observer.disconnect();
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
				aria-label={expanded ? lessLabel : moreLabel}
				title={expanded ? lessLabel : moreLabel}
				onclick={() => (expanded = !expanded)}
			>
				{#if expanded}
					<svg
						viewBox="0 0 24 24"
						width="22"
						height="22"
						fill="none"
						stroke="currentColor"
						stroke-width="2.2"
						stroke-linecap="round"
						stroke-linejoin="round"
						aria-hidden="true"
					>
						<path d="m18 15-6-6-6 6" />
					</svg>
				{:else}
					<svg viewBox="0 0 24 24" width="22" height="22" fill="currentColor" aria-hidden="true">
						<circle cx="6" cy="12" r="1.75" />
						<circle cx="12" cy="12" r="1.75" />
						<circle cx="18" cy="12" r="1.75" />
					</svg>
				{/if}
			</button>
		{/if}
	</div>
{/if}

<style>
	.expandable-text {
		display: flex;
		flex-direction: column;
		align-items: stretch;
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
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 100%;
		min-height: 32px;
		padding: var(--space-xs) 0;
		border: none;
		border-radius: var(--radius-sm);
		background: transparent;
		color: var(--color-text-muted);
		cursor: pointer;
	}

	.toggle-btn:hover {
		color: var(--color-primary);
	}
</style>
