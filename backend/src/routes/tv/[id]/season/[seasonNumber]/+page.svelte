<script lang="ts">
	import AppPromoBanner from '$lib/components/core/AppPromoBanner.svelte';
	import CreditsInfo from '$lib/components/core/CreditsInfo.svelte';
	import ExpandableText from '$lib/components/core/ExpandableText.svelte';
	import ExternalLinks from '$lib/components/core/ExternalLinks.svelte';
	import MediaCarousel from '$lib/components/core/MediaCarousel.svelte';
	import PosterImage from '$lib/components/core/PosterImage.svelte';
	import RatingBadges from '$lib/components/titles/RatingBadges.svelte';
	import SeoHead from '$lib/components/core/SeoHead.svelte';
	import TrailerModal from '$lib/components/titles/TrailerModal.svelte';
	import { TMDB_IMAGE_SIZE } from '$lib/constants/urls';
	import { t, tw } from '$lib/i18n';
	import { formatDate } from '$lib/utils/date';
	import type { PageData } from './$types';

	interface Props {
		data: PageData;
	}

	let { data }: Props = $props();
	const season = $derived(data.season);
	const hasPrevSeason = $derived(season.seasonNumber > 1);
	const hasNextSeason = $derived(
		season.totalSeasons > 0 && season.seasonNumber < season.totalSeasons
	);

	const seasonPosters = $derived.by(() => {
		if (season.images.length > 0) return season.images;
		return season.posterPath ? [season.posterPath] : [];
	});
</script>

<SeoHead
	title={data.seo.title}
	description={data.seo.description}
	canonicalPath={data.seo.canonicalPath}
	ogType="video.tv_show"
	ogImage={data.seo.ogImage}
	locale={data.locale}
	jsonLd={data.seo.jsonLd}
/>

<article class="season-page content-container">
	<nav class="breadcrumb" aria-label="Breadcrumb">
		<a class="back-link" href={`/tv/${season.tvId}`}>
			&larr; {season.seriesName}
		</a>

		{#if hasPrevSeason || hasNextSeason}
			<div class="header-season-nav" role="group" aria-label={t(data.locale, 'selectSeason')}>
				{#if hasPrevSeason}
					<a
						class="season-nav-btn"
						href={`/tv/${season.tvId}/season/${season.seasonNumber - 1}`}
						aria-label={t(data.locale, 'seasonLabel', { count: season.seasonNumber - 1 })}
						title={t(data.locale, 'seasonLabel', { count: season.seasonNumber - 1 })}
					>
						<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
							<path d="M15 18l-6-6 6-6" />
						</svg>
					</a>
				{:else}
					<span class="season-nav-btn is-disabled" aria-hidden="true">
						<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2">
							<path d="M15 18l-6-6 6-6" />
						</svg>
					</span>
				{/if}

				{#if hasNextSeason}
					<a
						class="season-nav-btn"
						href={`/tv/${season.tvId}/season/${season.seasonNumber + 1}`}
						aria-label={t(data.locale, 'seasonLabel', { count: season.seasonNumber + 1 })}
						title={t(data.locale, 'seasonLabel', { count: season.seasonNumber + 1 })}
					>
						<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2" aria-hidden="true">
							<path d="M9 18l6-6-6-6" />
						</svg>
					</a>
				{:else}
					<span class="season-nav-btn is-disabled" aria-hidden="true">
						<svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.2">
							<path d="M9 18l6-6-6-6" />
						</svg>
					</span>
				{/if}
			</div>
		{/if}
	</nav>

	<header class="season-header">
		<div class="poster-col">
			<MediaCarousel
				images={seasonPosters}
				fallbackType="tvshow-poster"
				alt={season.name}
				aspectRatio="2 / 3"
				size={TMDB_IMAGE_SIZE.w500}
				firstPriority="high"
				label={t(data.locale, 'gallery')}
			/>
		</div>

		<div class="summary-col">
			<p class="series-kicker">{season.seriesName}</p>
			<h1 class="season-heading">
				{season.name || t(data.locale, 'seasonLabel', { count: season.seasonNumber })}
			</h1>

			{#if season.airDate}
				<div class="meta-row">
					<span>{formatDate(season.airDate, data.locale)}</span>
				</div>
			{/if}

			<div class="actions-row">
				<RatingBadges tmdbVoteAverage={season.voteAverage} />
				<TrailerModal
					videos={season.videos}
					playLabel={tw(data.locale, 'playTrailer')}
					closeLabel={tw(data.locale, 'close')}
					trailerLabel={t(data.locale, 'trailer')}
				/>
			</div>
		</div>

		<div class="overview-block">
			{#if season.overview}
				<ExpandableText
					text={season.overview}
					maxLines={5}
					moreLabel={tw(data.locale, 'showMore')}
					lessLabel={tw(data.locale, 'showLess')}
				/>
			{:else}
				<p class="missing-description">{t(data.locale, 'missingDescription')}</p>
			{/if}
		</div>
	</header>

	<CreditsInfo crew={season.crew} mediaType="tv" locale={data.locale} />

	<section class="section-block">
		<ExternalLinks
			mediaType="tv"
			id={season.tvId}
			seasonNumber={season.seasonNumber}
			heading={t(data.locale, 'watchOn')}
		/>
	</section>

	{#if season.episodes.length > 0}
		<section class="section-block" aria-labelledby="episodes-heading">
			<h2 id="episodes-heading" class="section-title episodes-heading">
				{tw(data.locale, 'episodesCount', { count: season.episodes.length })}
			</h2>

			<ul class="episode-list">
				{#each season.episodes as ep (ep.id || ep.episodeNumber)}
					<li>
						<a
							class="episode-card"
							href={`/tv/${season.tvId}/season/${season.seasonNumber}/episode/${ep.episodeNumber}`}
						>
							<div class="episode-still">
								<PosterImage
									path={ep.stillPath}
									fallbackType="tvshow"
									alt={ep.name}
									size={TMDB_IMAGE_SIZE.w500}
									aspectRatio="16 / 9"
									radius="var(--radius-card)"
									lazy={true}
								/>
							</div>

							<div class="episode-info">
								<div class="episode-top">
									<span class="episode-num">
										{t(data.locale, 'episodeLabel', { count: ep.episodeNumber })}
									</span>
									{#if ep.voteAverage > 0}
										<span class="episode-rating">&#9733; {ep.voteAverage.toFixed(1)}</span>
									{/if}
								</div>
								<h3 class="episode-title">{ep.name}</h3>
								<div class="episode-meta">
									{#if ep.airDate}
										<span>{formatDate(ep.airDate, data.locale)}</span>
									{/if}
									{#if ep.runtime}
										<span>{ep.runtime} {tw(data.locale, 'minutesShort')}</span>
									{/if}
								</div>
								{#if ep.overview}
									<p class="episode-overview">{ep.overview}</p>
								{/if}
							</div>
						</a>
					</li>
				{/each}
			</ul>
		</section>
	{/if}

	{#if hasPrevSeason || hasNextSeason}
		<nav class="season-pager" aria-label={t(data.locale, 'selectSeason')}>
			{#if hasPrevSeason}
				<a
					class="pager-link"
					href={`/tv/${season.tvId}/season/${season.seasonNumber - 1}`}
				>
					&larr; {t(data.locale, 'seasonLabel', { count: season.seasonNumber - 1 })}
				</a>
			{:else}
				<span></span>
			{/if}
			{#if hasNextSeason}
				<a
					class="pager-link"
					href={`/tv/${season.tvId}/season/${season.seasonNumber + 1}`}
				>
					{t(data.locale, 'seasonLabel', { count: season.seasonNumber + 1 })} &rarr;
				</a>
			{/if}
		</nav>
	{/if}

	<section class="section-block">
		<AppPromoBanner locale={data.locale} />
	</section>
</article>

<style>
	.season-page {
		display: flex;
		flex-direction: column;
		gap: var(--space-xl);
		padding-block: var(--space-lg);
	}

	.breadcrumb {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-md);
	}

	.back-link {
		display: inline-flex;
		align-items: center;
		gap: var(--space-xs);
		color: var(--color-primary);
		font-weight: 600;
		font-size: var(--text-body-sm);
		min-width: 0;
	}

	.header-season-nav {
		display: inline-flex;
		align-items: center;
		gap: var(--space-xs);
		flex-shrink: 0;
	}

	.season-nav-btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 2rem;
		height: 2rem;
		border-radius: var(--radius-sm);
		background-color: var(--color-surface);
		border: 1px solid var(--color-outline);
		color: var(--color-text);
		transition: border-color 150ms ease, color 150ms ease;
	}

	.season-nav-btn:hover:not(.is-disabled) {
		border-color: var(--color-primary);
		color: var(--color-primary);
	}

	.season-nav-btn.is-disabled {
		opacity: 0.35;
	}

	.back-link:hover {
		text-decoration: underline;
	}

	.season-header {
		display: grid;
		grid-template-columns: 180px minmax(0, 1fr);
		column-gap: var(--space-xl);
		align-items: start;
	}

	.poster-col {
		grid-column: 1;
		grid-row: 1 / span 2;
	}

	.summary-col {
		grid-column: 2;
		grid-row: 1;
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
		min-width: 0;
	}

	.overview-block {
		grid-column: 2;
		grid-row: 2;
		margin-block-start: var(--space-md);
		min-width: 0;
	}

	.missing-description {
		font-size: var(--text-body-md);
		color: var(--color-text-muted);
	}

	@media (max-width: 600px) {
		.season-header {
			grid-template-columns: 130px minmax(0, 1fr);
			column-gap: var(--space-md);
		}

		.poster-col {
			grid-row: 1;
		}

		.overview-block {
			grid-column: 1 / -1;
		}
	}

	.series-kicker {
		font-size: var(--text-body-sm);
		color: var(--color-primary);
		font-weight: 700;
	}

	.season-heading {
		font-size: clamp(1.35rem, 2.5vw, 1.9rem);
		font-weight: 800;
		line-height: 1.2;
	}

	.meta-row {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-md);
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
	}

	.actions-row {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-md);
		width: 100%;
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

	.episodes-heading {
		padding-block-end: var(--space-md);
		border-block-end: 1px solid var(--color-border);
	}

	.episode-list {
		display: flex;
		flex-direction: column;
		gap: var(--space-md);
		list-style: none;
		padding: 0;
	}

	.episode-card {
		display: grid;
		grid-template-columns: 196px minmax(0, 1fr);
		gap: var(--space-md);
		padding: var(--space-md);
		border-radius: var(--radius-card);
		background-color: var(--color-surface);
		border: 1px solid var(--color-border);
		transition: border-color 150ms ease;
	}

	.episode-card:hover {
		border-color: var(--color-primary);
	}

	@media (max-width: 600px) {
		.episode-card {
			grid-template-columns: 1fr;
		}
	}

	.episode-info {
		display: flex;
		flex-direction: column;
		gap: var(--space-xs);
		min-width: 0;
	}

	.episode-top {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-sm);
	}

	.episode-num {
		font-size: var(--text-body-sm);
		font-weight: 700;
		color: var(--color-primary);
	}

	.episode-rating {
		font-size: var(--text-body-sm);
		font-weight: 700;
		color: var(--color-gold);
		font-variant-numeric: tabular-nums;
	}

	.episode-title {
		font-size: var(--text-title-md);
		font-weight: 700;
	}

	.episode-meta {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-md);
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
	}

	.episode-overview {
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 3;
		line-clamp: 3;
		overflow: hidden;
	}

	.season-pager {
		display: flex;
		justify-content: space-between;
		gap: var(--space-md);
		padding-block-start: var(--space-md);
		border-block-start: 1px solid var(--color-border);
	}

	.pager-link {
		padding: var(--space-sm) var(--space-md);
		border-radius: var(--radius-sm);
		background-color: var(--color-surface);
		border: 1px solid var(--color-outline);
		font-size: var(--text-body-sm);
		font-weight: 600;
	}

	.pager-link:hover {
		border-color: var(--color-primary);
	}
</style>
