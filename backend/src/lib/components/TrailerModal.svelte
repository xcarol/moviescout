<script lang="ts">
	import { youtubeEmbedUrl } from '$lib/constants/urls';
	import type { TmdbVideo } from '$lib/types/tmdb';

	interface Props {
		videos: TmdbVideo[];
		playLabel: string;
		closeLabel: string;
		trailerLabel: string;
	}

	let { videos, playLabel, closeLabel, trailerLabel }: Props = $props();

	const headingId = $props.id();

	let dialogEl: HTMLDialogElement | undefined = $state();
	let isOpen = $state(false);
	let selectedIndex = $state(0);

	const activeVideo = $derived(videos[selectedIndex] ?? videos[0]);

	function openModal() {
		if (!dialogEl || !activeVideo) return;
		isOpen = true;
		dialogEl.showModal();
	}

	function closeModal() {
		dialogEl?.close();
	}

	function handleDialogClose() {
		isOpen = false;
		if (dialogEl) {
			dialogEl.returnValue = '';
		}
	}

	$effect(() => {
		const dialog = dialogEl;
		if (!dialog || 'closedBy' in HTMLDialogElement.prototype) return;

		// Light-dismiss fallback for browsers without native <dialog closedby="any">.
		const isOutside = (e: PointerEvent) => {
			const rect = dialog.getBoundingClientRect();
			return (
				e.clientX < rect.left ||
				e.clientX > rect.right ||
				e.clientY < rect.top ||
				e.clientY > rect.bottom
			);
		};

		let pressedOutside = false;
		const onPointerDown = (e: PointerEvent) => {
			pressedOutside = isOutside(e);
		};
		const onPointerUp = (e: PointerEvent) => {
			if (pressedOutside && isOutside(e)) {
				dialog.close();
			}
			pressedOutside = false;
		};

		dialog.addEventListener('pointerdown', onPointerDown);
		dialog.addEventListener('pointerup', onPointerUp);

		return () => {
			dialog.removeEventListener('pointerdown', onPointerDown);
			dialog.removeEventListener('pointerup', onPointerUp);
		};
	});
</script>

{#if videos.length > 0}
	<button type="button" class="trailer-trigger" onclick={openModal}>
		<svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor" aria-hidden="true">
			<path d="M8 5v14l11-7z" />
		</svg>
		<span>{playLabel}</span>
	</button>

	<dialog
		bind:this={dialogEl}
		class="trailer-dialog"
		closedby="any"
		aria-labelledby={headingId}
		onclose={handleDialogClose}
	>
		<div class="dialog-header">
			<h2 id={headingId} class="dialog-title">
				{activeVideo?.name || trailerLabel}
			</h2>
			<button
				type="button"
				class="close-btn"
				aria-label={closeLabel}
				onclick={closeModal}
			>
				<svg
					viewBox="0 0 24 24"
					width="20"
					height="20"
					fill="none"
					stroke="currentColor"
					stroke-width="2"
					aria-hidden="true"
				>
					<path d="M18 6 6 18M6 6l12 12" />
				</svg>
			</button>
		</div>

		{#if videos.length > 1}
			<div class="video-tabs" role="tablist" aria-label={trailerLabel}>
				{#each videos as video, idx (video.key)}
					<button
						type="button"
						role="tab"
						class="video-tab"
						aria-selected={idx === selectedIndex}
						onclick={() => (selectedIndex = idx)}
					>
						{video.name || `${trailerLabel} ${idx + 1}`}
					</button>
				{/each}
			</div>
		{/if}

		<div class="player-frame">
			{#if isOpen && activeVideo}
				<iframe
					src={youtubeEmbedUrl(activeVideo.key)}
					title={activeVideo.name || trailerLabel}
					allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
					allowfullscreen
				></iframe>
			{/if}
		</div>
	</dialog>
{/if}

<style>
	.trailer-trigger {
		display: inline-flex;
		align-items: center;
		gap: var(--space-xs);
		min-height: 40px;
		padding: var(--space-sm) var(--space-lg);
		border: none;
		border-radius: var(--radius-sm);
		background-color: var(--color-primary);
		color: var(--color-on-primary);
		font-weight: 700;
		font-size: var(--text-body-sm);
		cursor: pointer;
	}

	.trailer-trigger:hover {
		background-color: var(--color-primary-hover);
	}

	.trailer-dialog {
		margin: auto;
		padding: 0;
		width: min(92vw, 840px);
		max-height: 90dvh;
		border: 1px solid var(--color-border);
		border-radius: var(--radius-lg);
		background-color: var(--color-surface);
		color: var(--color-text);
	}

	.trailer-dialog[open] {
		display: flex;
		flex-direction: column;
	}

	dialog:modal {
		overscroll-behavior: contain;
	}

	dialog::backdrop {
		overflow: hidden;
		overscroll-behavior: contain;
		background-color: rgba(0, 0, 0, 0.78);
		backdrop-filter: blur(4px);
	}

	.dialog-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-md);
		padding: var(--space-md) var(--space-lg);
		border-block-end: 1px solid var(--color-border);
	}

	.dialog-title {
		font-size: var(--text-title-md);
		font-weight: 700;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.close-btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		min-width: 36px;
		min-height: 36px;
		border: 1px solid var(--color-outline);
		border-radius: var(--radius-sm);
		background-color: var(--color-surface-elevated);
		color: var(--color-text);
		cursor: pointer;
		flex-shrink: 0;
	}

	.close-btn:hover {
		border-color: var(--color-primary);
	}

	.video-tabs {
		display: flex;
		gap: var(--space-xs);
		overflow-x: auto;
		padding: var(--space-sm) var(--space-lg);
		border-block-end: 1px solid var(--color-border);
	}

	.video-tab {
		flex-shrink: 0;
		max-width: 220px;
		padding: var(--space-xs) var(--space-md);
		border-radius: var(--radius-sm);
		border: 1px solid var(--color-outline);
		background-color: var(--color-surface-elevated);
		color: var(--color-text-muted);
		font-size: var(--text-body-sm);
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		cursor: pointer;
	}

	.video-tab[aria-selected='true'] {
		border-color: var(--color-primary);
		background-color: var(--color-primary);
		color: var(--color-on-primary);
		font-weight: 600;
	}

	.player-frame {
		position: relative;
		width: 100%;
		aspect-ratio: 16 / 9;
		background-color: var(--color-bg);
	}

	.player-frame iframe {
		width: 100%;
		height: 100%;
		border: 0;
		display: block;
	}
</style>
