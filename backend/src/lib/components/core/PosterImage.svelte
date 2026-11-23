<script lang="ts">
	import { browser } from '$app/environment';
	import { tmdbImageUrl, type TmdbImageSize } from '$lib/constants/urls';

	export type PosterFallbackType =
		| 'movie'
		| 'movie-poster'
		| 'tvshow'
		| 'tvshow-poster'
		| 'person'
		| 'backdrop'
		| 'provider';

	const FALLBACK_ASSETS: Record<PosterFallbackType, string> = {
		movie: '/assets/movie.png',
		'movie-poster': '/assets/movie-poster.png',
		tvshow: '/assets/tvshow.png',
		'tvshow-poster': '/assets/tvshow-poster.png',
		person: '/assets/person.png',
		backdrop: '/assets/backdrop-placeholder.png',
		provider: '/assets/provider-placeholder.png'
	};

	interface Props {
		path?: string | null;
		fallbackType: PosterFallbackType;
		alt: string;
		size?: TmdbImageSize;
		aspectRatio?: string;
		priority?: 'high' | 'low' | 'normal';
		lazy?: boolean;
		radius?: string;
		width?: number;
		height?: number;
		sizes?: string;
		decorative?: boolean;
	}

	let {
		path = null,
		fallbackType,
		alt,
		size = 'w500',
		aspectRatio = '2 / 3',
		priority = 'normal',
		lazy = false,
		radius = 'var(--radius-card)',
		width,
		height,
		sizes,
		decorative = false
	}: Props = $props();

	let failed = $state(false);
	let imgEl: HTMLImageElement | undefined = $state();

	const fallbackSrc = $derived(FALLBACK_ASSETS[fallbackType]);

	const resolvedSrc = $derived.by(() => {
		if (failed || !path) return fallbackSrc;
		if (path.startsWith('http://') || path.startsWith('https://') || path.startsWith('/assets/')) {
			return path;
		}
		return tmdbImageUrl(path, size);
	});

	const effectiveFetchPriority = $derived(
		priority === 'high' ? 'high' : priority === 'low' ? 'low' : undefined
	);
	const effectiveLoading = $derived(
		priority === 'high' ? undefined : lazy || priority === 'low' ? 'lazy' : undefined
	);

	$effect(() => {
		// Reset error state when the requested path changes across client-side navigations.
		void path;
		failed = false;
		if (browser && imgEl && imgEl.complete && imgEl.naturalWidth === 0 && path) {
			failed = true;
		}
	});

	function handleError() {
		if (!failed) {
			failed = true;
		}
	}
</script>

<div
	class="poster-frame"
	style:aspect-ratio={aspectRatio}
	style:border-radius={radius}
>
	<img
		bind:this={imgEl}
		src={resolvedSrc}
		alt={decorative ? '' : alt}
		aria-hidden={decorative ? 'true' : undefined}
		{width}
		{height}
		{sizes}
		loading={effectiveLoading}
		fetchpriority={effectiveFetchPriority}
		decoding={priority === 'high' ? 'sync' : 'async'}
		onerror={handleError}
	/>
</div>

<style>
	.poster-frame {
		position: relative;
		width: 100%;
		overflow: hidden;
		background-color: var(--color-surface-elevated);
	}

	img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
</style>
