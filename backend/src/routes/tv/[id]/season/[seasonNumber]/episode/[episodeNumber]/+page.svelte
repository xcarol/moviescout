<script lang="ts">
	import AppPromoBanner from '$lib/components/AppPromoBanner.svelte';
	import ExpandableText from '$lib/components/ExpandableText.svelte';
	import HorizontalRail from '$lib/components/HorizontalRail.svelte';
	import MediaCarousel from '$lib/components/MediaCarousel.svelte';
	import PersonChip from '$lib/components/PersonChip.svelte';
	import RatingBadges from '$lib/components/RatingBadges.svelte';
	import SeoHead from '$lib/components/SeoHead.svelte';
	import TrailerModal from '$lib/components/TrailerModal.svelte';
	import { TMDB_IMAGE_SIZE } from '$lib/constants/urls';
	import { t, translateJob, tw } from '$lib/i18n';
	import type { PageData } from './$types';

	interface Props {
		data: PageData;
	}

	let { data }: Props = $props();
	const ep = $derived(data.episode);

	const episodeStills = $derived.by(() => {
		if (ep.images.length > 0) return ep.images;
		return ep.stillPath ? [ep.stillPath] : [];
	});

	const episodeCode = $derived(
		`S${String(ep.seasonNumber).padStart(2, '0')}E${String(ep.episodeNumber).padStart(2, '0')}`
	);
</script>

<SeoHead
	title={data.seo.title}
	description={data.seo.description}
	canonicalPath={data.seo.canonicalPath}
	ogType="video.episode"
	ogImage={data.seo.ogImage}
	locale={data.locale}
	jsonLd={data.seo.jsonLd}
/>

<article class="episode-page content-container">
	<nav class="breadcrumb" aria-label="Breadcrumb">
		<a class="crumb-link" href={`/tv/${ep.tvId}`}>{ep.seriesName}</a>
		<span aria-hidden="true">/</span>
		<a class="crumb-link" href={`/tv/${ep.tvId}/season/${ep.seasonNumber}`}>
			{ep.seasonName || t(data.locale, 'seasonLabel', { count: ep.seasonNumber })}
		</a>
	</nav>

	<div class="hero-still">
		<MediaCarousel
			images={episodeStills}
			fallbackType="tvshow"
			alt={ep.name}
			aspectRatio="16 / 9"
			size={TMDB_IMAGE_SIZE.w780}
			firstPriority="high"
			label={t(data.locale, 'gallery')}
			radius="var(--radius-chip)"
		/>
	</div>

	<header class="episode-header">
		<span class="episode-kicker">{episodeCode}</span>
		<h1 class="episode-heading">{ep.name}</h1>

		<div class="meta-row">
			{#if ep.airDate}
				<span>{tw(data.locale, 'airDate')}: {ep.airDate}</span>
			{/if}
			{#if ep.runtime}
				<span>{ep.runtime} {tw(data.locale, 'minutesShort')}</span>
			{/if}
		</div>

		<div class="actions-row">
			<RatingBadges tmdbVoteAverage={ep.voteAverage} tmdbVoteCount={ep.voteCount} />
			<TrailerModal
				videos={ep.videos}
				playLabel={tw(data.locale, 'playTrailer')}
				closeLabel={tw(data.locale, 'close')}
				trailerLabel={t(data.locale, 'trailer')}
			/>
		</div>
	</header>

	{#if ep.overview}
		<section class="section-block">
			<ExpandableText
				text={ep.overview}
				maxLines={6}
				moreLabel={tw(data.locale, 'showMore')}
				lessLabel={tw(data.locale, 'showLess')}
			/>
		</section>
	{/if}

	{#if ep.episodeNumber > 1 || (ep.totalEpisodesInSeason > 0 && ep.episodeNumber < ep.totalEpisodesInSeason)}
		<nav class="episode-pager" aria-label={t(data.locale, 'episodes')}>
			{#if ep.episodeNumber > 1}
				<a
					class="pager-link"
					href={`/tv/${ep.tvId}/season/${ep.seasonNumber}/episode/${ep.episodeNumber - 1}`}
				>
					&larr; {tw(data.locale, 'previousEpisode')}
				</a>
			{:else}
				<span></span>
			{/if}
			{#if ep.totalEpisodesInSeason > 0 && ep.episodeNumber < ep.totalEpisodesInSeason}
				<a
					class="pager-link"
					href={`/tv/${ep.tvId}/season/${ep.seasonNumber}/episode/${ep.episodeNumber + 1}`}
				>
					{tw(data.locale, 'nextEpisode')} &rarr;
				</a>
			{/if}
		</nav>
	{/if}

	<section class="section-block">
		<AppPromoBanner locale={data.locale} />
	</section>

	{#if ep.cast.length > 0 || ep.guestStars.length > 0}
		<section class="section-block">
			<HorizontalRail title={t(data.locale, 'cast')}>
				{#each [...ep.cast, ...ep.guestStars].slice(0, 20) as person (`${person.id}-${person.role}`)}
					<PersonChip {person} />
				{/each}
			</HorizontalRail>
		</section>
	{/if}

	{#if ep.crew.length > 0}
		<section class="section-block">
			<HorizontalRail title={t(data.locale, 'crew')}>
				{#each ep.crew.slice(0, 20) as person (person.id)}
					<PersonChip {person} roleText={translateJob(person.role, data.locale)} />
				{/each}
			</HorizontalRail>
		</section>
	{/if}
</article>

<style>
	.episode-page {
		display: flex;
		flex-direction: column;
		gap: var(--space-xl);
		padding-block: var(--space-lg);
	}

	.breadcrumb {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: var(--space-sm);
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
	}

	.crumb-link {
		color: var(--color-primary);
		font-weight: 600;
	}

	.crumb-link:hover {
		text-decoration: underline;
	}

	.episode-header {
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
	}

	.episode-kicker {
		align-self: flex-start;
		padding: var(--space-xxs) var(--space-sm);
		border-radius: var(--radius-full);
		background-color: var(--color-surface-elevated);
		color: var(--color-primary);
		font-size: var(--text-body-sm);
		font-weight: 700;
	}

	.episode-heading {
		font-size: clamp(1.35rem, 2.5vw, 2rem);
		font-weight: 800;
		line-height: 1.2;
	}

	.meta-row {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-md);
		color: var(--color-text-muted);
		font-size: var(--text-body-sm);
	}

	.actions-row {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		justify-content: space-between;
		gap: var(--space-md);
		width: 100%;
		margin-block-start: var(--space-xs);
	}

	.section-block {
		padding-block-start: var(--space-lg);
		border-block-start: 1px solid var(--color-border);
	}

	.episode-pager {
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
