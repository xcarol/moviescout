<script lang="ts">
	import AppPromoBanner from '$lib/components/AppPromoBanner.svelte';
	import ExpandableText from '$lib/components/ExpandableText.svelte';
	import ExternalLinks from '$lib/components/ExternalLinks.svelte';
	import MediaCarousel from '$lib/components/MediaCarousel.svelte';
	import PosterImage from '$lib/components/PosterImage.svelte';
	import SeoHead from '$lib/components/SeoHead.svelte';
	import TitleChip from '$lib/components/TitleChip.svelte';
	import { TMDB_IMAGE_SIZE } from '$lib/constants/urls';
	import { t, tw } from '$lib/i18n';
	import type { PageData } from './$types';

	interface Props {
		data: PageData;
	}

	let { data }: Props = $props();
	const collection = $derived(data.collection);

	const heroImages = $derived.by(() => {
		if (collection.images.length > 0) return collection.images;
		return collection.backdropPath ? [collection.backdropPath] : [];
	});
</script>

<SeoHead
	title={data.seo.title}
	description={data.seo.description}
	canonicalPath={data.seo.canonicalPath}
	ogType="website"
	ogImage={data.seo.ogImage}
	locale={data.locale}
	jsonLd={data.seo.jsonLd}
/>

<article class="collection-page content-container">
	<div class="hero-backdrop">
		<MediaCarousel
			images={heroImages}
			fallbackType="backdrop"
			alt={collection.name}
			aspectRatio="16 / 9"
			size={TMDB_IMAGE_SIZE.w780}
			firstPriority="high"
			label={t(data.locale, 'gallery')}
			radius="var(--radius-chip)"
		/>
	</div>

	<header class="collection-header">
		<div class="poster-col">
			<PosterImage
				path={collection.posterPath}
				fallbackType="movie-poster"
				alt={collection.name}
				size={TMDB_IMAGE_SIZE.w500}
				aspectRatio="2 / 3"
				radius="var(--radius-chip)"
				priority={heroImages.length === 0 ? 'high' : 'normal'}
			/>
		</div>

		<div class="summary-col">
			<span class="type-pill">{t(data.locale, 'collection')}</span>
			<h1 class="collection-heading">{collection.name}</h1>
			<p class="count-meta">
				{tw(data.locale, 'moviesCountLabel', { count: collection.parts.length })}
			</p>

			{#if collection.overview}
				<ExpandableText
					text={collection.overview}
					maxLines={5}
					moreLabel={tw(data.locale, 'showMore')}
					lessLabel={tw(data.locale, 'showLess')}
				/>
			{/if}
		</div>
	</header>

	{#if collection.parts.length > 0}
		<section class="section-block" aria-labelledby="parts-heading">
			<h2 id="parts-heading" class="section-title">
				{tw(data.locale, 'collectionParts')}
			</h2>

			<div class="parts-grid">
				{#each collection.parts as part (part.id)}
					<TitleChip item={part} lazy={true} />
				{/each}
			</div>
		</section>
	{/if}

	<section class="section-block">
		<AppPromoBanner locale={data.locale} />
	</section>

	<section class="section-block">
		<ExternalLinks
			mediaType="collection"
			id={collection.id}
			heading={tw(data.locale, 'externalLinks')}
		/>
	</section>
</article>

<style>
	.collection-page {
		display: flex;
		flex-direction: column;
		gap: var(--space-xl);
		padding-block: var(--space-lg);
	}

	.collection-header {
		display: grid;
		grid-template-columns: 160px minmax(0, 1fr);
		gap: var(--space-xl);
		align-items: start;
	}

	@media (max-width: 600px) {
		.collection-header {
			grid-template-columns: 120px minmax(0, 1fr);
			gap: var(--space-md);
		}
	}

	.summary-col {
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
		min-width: 0;
	}

	.type-pill {
		align-self: flex-start;
		padding: var(--space-xxs) var(--space-sm);
		border-radius: var(--radius-full);
		background-color: var(--color-surface-elevated);
		color: var(--color-primary);
		font-size: var(--text-body-sm);
		font-weight: 700;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.collection-heading {
		font-size: clamp(1.35rem, 2.5vw, 2rem);
		font-weight: 800;
		line-height: 1.2;
	}

	.count-meta {
		color: var(--color-text-muted);
		font-size: var(--text-body-sm);
		font-weight: 600;
	}

	.section-block {
		padding-block-start: var(--space-lg);
		border-block-start: 1px solid var(--color-border);
	}

	.section-title {
		font-size: var(--text-title-md);
		font-weight: 700;
		margin-block-end: var(--space-md);
	}

	.parts-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(144px, 1fr));
		gap: var(--space-md);
	}

	.parts-grid :global(.title-chip) {
		flex: unset;
		width: 100%;
	}
</style>
