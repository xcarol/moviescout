<script lang="ts">
	import PosterImage, { type PosterFallbackType } from './PosterImage.svelte';

	interface Props {
		images: string[];
		fallbackType: PosterFallbackType;
		alt: string;
		aspectRatio?: string;
		size?: 'w500' | 'w780' | 'original';
		firstPriority?: 'high' | 'low' | 'normal';
		label?: string;
		radius?: string;
	}

	let {
		images,
		fallbackType,
		alt,
		aspectRatio = '16 / 9',
		size = 'w780',
		firstPriority = 'high',
		label = 'Gallery',
		radius = 'var(--radius-chip)'
	}: Props = $props();

	let trackEl: HTMLDivElement | undefined = $state();
	let prevBtnEl: HTMLButtonElement | undefined = $state();
	let nextBtnEl: HTMLButtonElement | undefined = $state();

	let currentIndex = $state(0);
	let settledIndex = $state(0);
	let announcement = $state('');
	let hasUserInteracted = $state(false);
	let pendingTarget: number | null = $state(null);
	let scrollDebounceTimer: ReturnType<typeof setTimeout> | undefined;
	let rafPending = false;

	const count = $derived(images.length);
	const isFiniteCarousel = $derived(count === 2);

	function getSlideElements(): HTMLElement[] {
		if (!trackEl) return [];
		return Array.from(trackEl.children) as HTMLElement[];
	}

	function getNearestSlideIndex(): number {
		if (!trackEl) return 0;
		const slides = getSlideElements();
		if (slides.length === 0) return 0;

		const trackCenter = trackEl.scrollLeft + trackEl.clientWidth / 2;
		let bestIdx = 0;
		let bestDistance = Number.POSITIVE_INFINITY;

		slides.forEach((slide, idx) => {
			const slideCenter = slide.offsetLeft + slide.offsetWidth / 2;
			const dist = Math.abs(slideCenter - trackCenter);
			if (dist < bestDistance) {
				bestDistance = dist;
				bestIdx = idx;
			}
		});

		return bestIdx;
	}

	function getVisualOrderedSlides(): Array<{ el: HTMLElement; index: number }> {
		return getSlideElements()
			.map((el, index) => ({
				el,
				index,
				left: el.offsetLeft
			}))
			.sort((a, b) => a.left - b.left)
			.map(({ el, index }) => ({ el, index }));
	}

	function scrollToSlide(targetIndex: number, behavior: ScrollBehavior) {
		if (!trackEl) return;
		const slides = getSlideElements();
		const target = slides[targetIndex];
		if (!target) return;

		const delta = target.offsetLeft - trackEl.scrollLeft;
		trackEl.scrollBy({ left: delta, behavior });
	}

	function applyInstantCompensation(updateVar: () => void, anchor: HTMLElement | undefined) {
		if (!trackEl || !anchor) return;

		const beforeLeft = anchor.offsetLeft;
		const prevSnap = trackEl.style.scrollSnapType;
		const prevBehavior = trackEl.style.scrollBehavior;

		trackEl.style.scrollSnapType = 'none';
		trackEl.style.scrollBehavior = 'auto';
		updateVar();

		const afterLeft = anchor.offsetLeft;
		const diff = afterLeft - beforeLeft;
		if (diff !== 0) {
			trackEl.scrollTo({ left: trackEl.scrollLeft + diff, behavior: 'instant' });
		}
		trackEl.style.scrollBehavior = prevBehavior;

		requestAnimationFrame(() => {
			if (!trackEl) return;
			trackEl.style.scrollSnapType = prevSnap;
		});
	}

	function syncParking(activeIdx: number) {
		if (!trackEl || count < 3) return;
		const slides = getSlideElements();
		const anchor = slides[activeIdx];
		if (!anchor) return;

		const prevVar = trackEl.style.getPropertyValue('--current');
		if (prevVar === String(activeIdx)) return;

		applyInstantCompensation(() => {
			trackEl?.style.setProperty('--current', String(activeIdx));
		}, anchor);
	}

	function handleSettled() {
		if (!trackEl) return;
		const nearest = getNearestSlideIndex();

		if (pendingTarget !== null && nearest !== pendingTarget) {
			return;
		}

		pendingTarget = null;
		currentIndex = nearest;

		if (count >= 3) {
			syncParking(nearest);
		}

		if (hasUserInteracted && nearest !== settledIndex) {
			settledIndex = nearest;
			announcement = `${nearest + 1} / ${count}`;
		} else {
			settledIndex = nearest;
		}

		if (isFiniteCarousel) {
			if (nearest === 0 && document.activeElement === prevBtnEl) {
				nextBtnEl?.focus();
			} else if (nearest === count - 1 && document.activeElement === nextBtnEl) {
				prevBtnEl?.focus();
			}
		}
	}

	function handleScroll() {
		if (!trackEl) return;

		if (pendingTarget === null && !rafPending) {
			rafPending = true;
			requestAnimationFrame(() => {
				rafPending = false;
				if (pendingTarget === null) {
					const nearest = getNearestSlideIndex();
					if (nearest !== currentIndex) {
						currentIndex = nearest;
					}
				}
			});
		}

		if (!('onscrollend' in window)) {
			clearTimeout(scrollDebounceTimer);
			scrollDebounceTimer = setTimeout(handleSettled, 140);
		}
	}

	function step(direction: -1 | 1) {
		if (!trackEl || count < 2) return;
		hasUserInteracted = true;

		const baseIndex = pendingTarget ?? currentIndex;

		if (isFiniteCarousel) {
			const next = Math.max(0, Math.min(count - 1, baseIndex + direction));
			if (next === baseIndex) return;
			pendingTarget = next;
			currentIndex = next;
			scrollToSlide(next, getScrollBehavior());
			return;
		}

		const ordered = getVisualOrderedSlides();
		const visualPos = ordered.findIndex((item) => item.index === baseIndex);
		if (visualPos === -1) return;

		const nextVisualPos = visualPos + direction;
		if (nextVisualPos < 0 || nextVisualPos >= ordered.length) return;

		const target = ordered[nextVisualPos];
		pendingTarget = target.index;
		currentIndex = target.index;
		const delta = target.el.offsetLeft - trackEl.scrollLeft;
		trackEl.scrollBy({ left: delta, behavior: getScrollBehavior() });
	}

	function jumpToMarker(targetIndex: number) {
		if (!trackEl || targetIndex === currentIndex) return;
		hasUserInteracted = true;

		if (count >= 3) {
			const slides = getSlideElements();
			const anchor = slides[currentIndex];
			if (anchor) {
				const beforeLeft = anchor.offsetLeft;
				const prevSnap = trackEl.style.scrollSnapType;
				const prevBehavior = trackEl.style.scrollBehavior;

				trackEl.style.scrollSnapType = 'none';
				trackEl.style.scrollBehavior = 'auto';
				trackEl.style.setProperty('--current', 'initial');
				const afterLeft = anchor.offsetLeft;
				if (afterLeft !== beforeLeft) {
					trackEl.scrollTo({
						left: trackEl.scrollLeft + (afterLeft - beforeLeft),
						behavior: 'instant'
					});
				}
				trackEl.style.scrollBehavior = prevBehavior;
				trackEl.style.scrollSnapType = prevSnap;
			}
		}

		pendingTarget = targetIndex;
		currentIndex = targetIndex;
		scrollToSlide(targetIndex, getScrollBehavior());
	}

	function getScrollBehavior(): ScrollBehavior {
		if (typeof window === 'undefined') return 'auto';
		return window.matchMedia('(prefers-reduced-motion: no-preference)').matches
			? 'smooth'
			: 'auto';
	}

	$effect(() => {
		const track = trackEl;
		if (!track || count < 2) return;

		if (!CSS.supports('order: sibling-count()')) {
			track.style.setProperty('--children-count', String(count));
		}

		if (count >= 3) {
			syncParking(0);
		}

		return () => {
			clearTimeout(scrollDebounceTimer);
		};
	});
</script>

{#if count === 0}
	<PosterImage path={null} {fallbackType} {alt} {aspectRatio} {size} {radius} />
{:else if count === 1}
	<PosterImage
		path={images[0]}
		{fallbackType}
		{alt}
		{aspectRatio}
		{size}
		priority={firstPriority}
		{radius}
	/>
{:else}
	<section class="carousel" aria-roledescription="carousel" aria-label={label}>
		<div class="carousel-stage" style:border-radius={radius}>
			<div class="carousel-controls">
				<button
					bind:this={prevBtnEl}
					type="button"
					class="nav-btn"
					aria-label="Previous slide"
					disabled={isFiniteCarousel && currentIndex === 0}
					onclick={() => step(-1)}
				>
					<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
						<path d="M15 18l-6-6 6-6" />
					</svg>
				</button>
				<button
					bind:this={nextBtnEl}
					type="button"
					class="nav-btn"
					aria-label="Next slide"
					disabled={isFiniteCarousel && currentIndex === count - 1}
					onclick={() => step(1)}
				>
					<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" aria-hidden="true">
						<path d="M9 18l6-6-6-6" />
					</svg>
				</button>
			</div>

			<div
				bind:this={trackEl}
				class="carousel-track"
				role="group"
				aria-label={label}
				onscroll={handleScroll}
				onscrollend={handleSettled}
			>
				{#each images as imgPath, idx (imgPath)}
					<div
						class="carousel-slide"
						role="group"
						aria-roledescription="slide"
						aria-label={`${idx + 1} / ${count}`}
					>
						<PosterImage
							path={imgPath}
							{fallbackType}
							alt={`${alt} (${idx + 1})`}
							{aspectRatio}
							{size}
							priority={idx === 0 ? firstPriority : 'low'}
							radius="0px"
						/>
					</div>
				{/each}
			</div>
		</div>

		<p class="visually-hidden" role="status" aria-live="polite">{announcement}</p>

		<nav class="carousel-markers" aria-label={label}>
			{#each images as imgPath, idx (imgPath)}
				<button
					type="button"
					class="marker-btn"
					aria-label={`${idx + 1} / ${count}`}
					aria-current={idx === currentIndex ? 'true' : undefined}
					onclick={() => jumpToMarker(idx)}
				>
					<span class="marker-dot"></span>
				</button>
			{/each}
		</nav>
	</section>
{/if}

<style>
	.carousel {
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
	}

	.carousel-stage {
		position: relative;
		overflow: hidden;
		background-color: var(--color-surface-elevated);
	}

	.carousel-controls {
		position: absolute;
		inset-inline: var(--space-sm);
		inset-block-start: 50%;
		transform: translateY(-50%);
		z-index: 2;
		display: flex;
		justify-content: space-between;
		pointer-events: none;
	}

	.nav-btn {
		pointer-events: auto;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 36px;
		height: 36px;
		border-radius: var(--radius-full);
		border: 1px solid rgba(255, 255, 255, 0.2);
		background-color: rgba(18, 18, 18, 0.72);
		color: var(--color-text);
		touch-action: manipulation;
		cursor: pointer;
	}

	.nav-btn:hover:not(:disabled) {
		background-color: var(--color-primary);
		color: var(--color-on-primary);
		border-color: var(--color-primary);
	}

	.nav-btn:disabled {
		opacity: 0.35;
		cursor: default;
	}

	.carousel-track {
		display: flex;
		overflow-x: auto;
		scroll-snap-type: x mandatory;
		overscroll-behavior-x: contain;
		scrollbar-width: none;
		touch-action: manipulation;
	}

	.carousel-track::-webkit-scrollbar {
		display: none;
	}

	@media (prefers-reduced-motion: no-preference) {
		.carousel-track {
			scroll-behavior: smooth;
		}
	}

	.carousel-slide {
		flex: 0 0 100%;
		scroll-snap-align: center;
	}

	.carousel-track > :first-child {
		order: clamp(0, var(--current) - (var(--children-count, sibling-count()) - 3), 1);
	}

	.carousel-track > :last-child {
		order: calc(-1 * clamp(0, 2 - var(--current), 1));
	}

	.carousel-markers {
		display: flex;
		justify-content: center;
		align-items: center;
		flex-wrap: wrap;
		gap: var(--space-xs);
	}

	.marker-btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		min-width: 24px;
		min-height: 24px;
		padding: 0;
		border: none;
		background: transparent;
		cursor: pointer;
		touch-action: manipulation;
	}

	.marker-dot {
		display: block;
		width: 8px;
		height: 8px;
		border-radius: var(--radius-full);
		background-color: var(--color-outline);
		transition: width 150ms ease, background-color 150ms ease;
	}

	.marker-btn[aria-current='true'] .marker-dot {
		width: 20px;
		background-color: var(--color-primary);
		outline: 1px solid var(--color-text);
	}
</style>
