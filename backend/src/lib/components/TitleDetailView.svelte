<script lang="ts">
	import { TMDB_IMAGE_SIZE } from '$lib/constants/urls';
	import {
		t,
		translateCountry,
		translateGenre,
		translateJob,
		translateLanguage,
		translateStatus,
		tw,
		type SupportedLocale
	} from '$lib/i18n';
	import type { TitleDetails } from '$lib/types/tmdb';
	import { getPrimaryHeaderCredit } from '$lib/utils/credits';
	import AppPromoBanner from './AppPromoBanner.svelte';
	import ClickableNames from './ClickableNames.svelte';
	import CreditsInfo from './CreditsInfo.svelte';
	import ExpandableText from './ExpandableText.svelte';
	import ExternalLinks from './ExternalLinks.svelte';
	import HorizontalRail from './HorizontalRail.svelte';
	import MediaCarousel from './MediaCarousel.svelte';
	import PersonChip from './PersonChip.svelte';
	import PosterImage from './PosterImage.svelte';
	import RatingBadges from './RatingBadges.svelte';
	import TitleChip from './TitleChip.svelte';
	import TrailerModal from './TrailerModal.svelte';
	import WatchProviders from './WatchProviders.svelte';

	interface Props {
		details: TitleDetails;
		locale: SupportedLocale;
	}

	let { details, locale }: Props = $props();

	const hasProviders = $derived(
		details.providers.free.length > 0 ||
			details.providers.ads.length > 0 ||
			details.providers.flatrate.length > 0 ||
			details.providers.rent.length > 0 ||
			details.providers.buy.length > 0
	);

	const isMovie = $derived(details.mediaType === 'movie');
	const heroImages = $derived.by(() => {
		if (details.images.length > 0) return details.images;
		return details.backdropPath ? [details.backdropPath] : [];
	});

	const releaseYear = $derived(details.releaseDate ? details.releaseDate.slice(0, 4) : '');

	const isUnreleased = $derived.by(() => {
		if (!details.releaseDate) return false;
		const ts = Date.parse(details.releaseDate);
		return !Number.isNaN(ts) && ts > Date.now();
	});

	const formattedRuntime = $derived.by(() => {
		if (isMovie && details.runtime) {
			const hours = Math.floor(details.runtime / 60);
			const minutes = details.runtime % 60;
			return hours > 0 ? `${hours}h ${minutes}m` : `${minutes}m`;
		}
		if (!isMovie && details.episodeRunTime.length > 0) {
			return `${details.episodeRunTime[0]} ${tw(locale, 'minutesShort')}`;
		}
		return '';
	});

	const headerCredit = $derived(getPrimaryHeaderCredit(details.crew));

	const visibleSeasons = $derived(
		[...details.seasons].sort((a, b) => {
			if (a.seasonNumber === 0) return 1;
			if (b.seasonNumber === 0) return -1;
			return a.seasonNumber - b.seasonNumber;
		})
	);
</script>

<article class="detail-page content-container">
	<div class="hero-backdrop">
		<MediaCarousel
			images={heroImages}
			fallbackType="backdrop"
			alt={details.title}
			aspectRatio="16 / 9"
			size={TMDB_IMAGE_SIZE.w780}
			firstPriority="high"
			label={t(locale, 'gallery')}
			radius="var(--radius-chip)"
		/>
	</div>

	<header class="title-header">
		<div class="poster-col">
			<PosterImage
				path={details.posterPath}
				fallbackType={isMovie ? 'movie-poster' : 'tvshow-poster'}
				alt={details.title}
				size={TMDB_IMAGE_SIZE.w500}
				aspectRatio="2 / 3"
				radius="var(--radius-chip)"
				priority={heroImages.length === 0 ? 'high' : 'normal'}
			/>
		</div>

		<div class="summary-col">
			<div class="type-pill">
				{isMovie ? t(locale, 'movie') : t(locale, 'tvShow')}
			</div>
			<h1 class="title-heading">{details.title}</h1>
			{#if details.tagline}
				<p class="tagline">{details.tagline}</p>
			{/if}

			<div class="meta-chips">
				{#if releaseYear}
					<span class="meta-item">{releaseYear}</span>
				{/if}
				{#if formattedRuntime}
					<span class="meta-item">{formattedRuntime}</span>
				{/if}
				{#if !isMovie && details.numberOfSeasons}
					<span class="meta-item">
						{tw(locale, 'seasonsCountLabel', { count: details.numberOfSeasons })}
					</span>
				{/if}
				{#if !isMovie && details.numberOfEpisodes}
					<span class="meta-item">
						{tw(locale, 'episodesCount', { count: details.numberOfEpisodes })}
					</span>
				{/if}
				{#if details.certification}
					<span class="cert-badge">{details.certification}</span>
				{/if}
			</div>

			{#if headerCredit}
				<div class="header-credit">
					<span class="header-credit-label">{t(locale, headerCredit.labelKey)}</span>
					<ClickableNames people={headerCredit.people} {locale} useEllipsis={true} />
				</div>
			{/if}

			{#if details.genres.length > 0}
				<ul class="genre-list">
					{#each details.genres as genre (genre.id)}
						<li class="genre-chip">
							{translateGenre(genre.id, locale) ?? genre.name}
						</li>
					{/each}
				</ul>
			{/if}

			<div class="actions-row">
				<RatingBadges
					tmdbVoteAverage={details.voteAverage}
					tmdbVoteCount={details.voteCount}
					omdbRatings={details.omdbRatings}
					{isUnreleased}
					notReleasedText={t(locale, 'notReleasedYet')}
				/>
				<TrailerModal
					videos={details.videos}
					playLabel={tw(locale, 'playTrailer')}
					closeLabel={tw(locale, 'close')}
					trailerLabel={t(locale, 'trailer')}
				/>
			</div>
		</div>
	</header>

	{#if details.overview}
		<section class="section-block">
			<ExpandableText
				text={details.overview}
				maxLines={4}
				moreLabel={tw(locale, 'showMore')}
				lessLabel={tw(locale, 'showLess')}
			/>
		</section>
	{/if}

	<section class="section-block meta-grid">
		{#if details.originalTitle}
			<div class="meta-field">
				<span class="field-label">{t(locale, 'originaTitle')}</span>
				<span class="field-value">{details.originalTitle}</span>
			</div>
		{/if}
		{#if details.releaseDate}
			<div class="meta-field">
				<span class="field-label">
					{isMovie ? tw(locale, 'releaseDate') : tw(locale, 'firstAirDate')}
				</span>
				<span class="field-value">{details.releaseDate}</span>
			</div>
		{/if}
		{#if details.originalLanguage}
			<div class="meta-field">
				<span class="field-label">{t(locale, 'originalLanguage')}</span>
				<span class="field-value">
					{translateLanguage(details.originalLanguage, locale)}
				</span>
			</div>
		{/if}
		{#if details.originCountry.length > 0}
			<div class="meta-field">
				<span class="field-label">{t(locale, 'originCountry')}</span>
				<span class="field-value">
					{details.originCountry.map((c) => translateCountry(c, locale)).join(', ')}
				</span>
			</div>
		{/if}
		{#if details.status}
			<div class="meta-field">
				<span class="field-label">{tw(locale, 'status')}</span>
				<span class="field-value">{translateStatus(details.status, locale)}</span>
			</div>
		{/if}
	</section>

	<CreditsInfo crew={details.crew} mediaType={details.mediaType} {locale} />

	{#if details.belongsToCollection}
		<section class="section-block">
			<a class="collection-card" href={`/collection/${details.belongsToCollection.id}`}>
				<div class="collection-thumb">
					<PosterImage
						path={details.belongsToCollection.posterPath}
						fallbackType="movie"
						alt={details.belongsToCollection.name}
						size={TMDB_IMAGE_SIZE.w185}
						aspectRatio="2 / 3"
						radius="var(--radius-sm)"
						lazy={true}
					/>
				</div>
				<div class="collection-info">
					<span class="collection-kicker">{t(locale, 'seeCollection')}</span>
					<span class="collection-name">{details.belongsToCollection.name}</span>
				</div>
			</a>
		</section>
	{/if}

	<section class="section-block">
		<ExternalLinks
			mediaType={details.mediaType}
			id={details.id}
			links={details.externalLinks}
			heading={t(locale, 'watchOn')}
		/>
	</section>

	{#if hasProviders}
		<section class="section-block">
			<WatchProviders providers={details.providers} {locale} />
		</section>
	{/if}

	<section class="section-block">
		<AppPromoBanner {locale} />
	</section>

	{#if !isMovie && visibleSeasons.length > 0}
		<section class="section-block">
			<HorizontalRail title={t(locale, 'selectSeason')}>
				{#each visibleSeasons as season (season.id || season.seasonNumber)}
					<a
						class="season-chip"
						href={`/tv/${details.id}/season/${season.seasonNumber}`}
					>
						<PosterImage
							path={season.posterPath}
							fallbackType="tvshow"
							alt={season.name}
							size={TMDB_IMAGE_SIZE.w300}
							aspectRatio="2 / 3"
							radius="0px"
							lazy={true}
						/>
						<div class="season-info">
							<p class="season-title">
								{season.name || t(locale, 'seasonLabel', { count: season.seasonNumber })}
							</p>
							<p class="season-meta">
								{tw(locale, 'episodesCount', { count: season.episodeCount })}
								{#if season.airDate}
									· {season.airDate.slice(0, 4)}
								{/if}
							</p>
						</div>
					</a>
				{/each}
			</HorizontalRail>
		</section>
	{/if}

	{#if details.cast.length > 0}
		<section class="section-block">
			<HorizontalRail title={t(locale, 'cast')}>
				{#each details.cast.slice(0, 20) as person (person.id)}
					<PersonChip {person} />
				{/each}
			</HorizontalRail>
		</section>
	{/if}

	{#if details.recommendations.length > 0}
		<section class="section-block">
			<HorizontalRail title={t(locale, 'recommended')}>
				{#each details.recommendations.slice(0, 20) as rec (`${rec.mediaType}-${rec.id}`)}
					<TitleChip item={rec} />
				{/each}
			</HorizontalRail>
		</section>
	{/if}

	{#if details.crew.length > 0}
		<section class="section-block">
			<HorizontalRail title={t(locale, 'crew')}>
				{#each details.crew.slice(0, 20) as person (person.id)}
					<PersonChip {person} roleText={translateJob(person.role, locale)} />
				{/each}
			</HorizontalRail>
		</section>
	{/if}

</article>

<style>
	.detail-page {
		display: flex;
		flex-direction: column;
		gap: var(--space-xl);
		padding-block: var(--space-lg);
	}

	.title-header {
		display: grid;
		grid-template-columns: 160px minmax(0, 1fr);
		gap: var(--space-xl);
		align-items: start;
	}

	@media (max-width: 600px) {
		.title-header {
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

	.title-heading {
		font-size: clamp(1.35rem, 2.5vw, 2rem);
		font-weight: 800;
		line-height: 1.2;
	}

	.tagline {
		color: var(--color-text-muted);
		font-style: italic;
		font-size: var(--text-body-md);
	}

	.meta-chips {
		display: flex;
		flex-wrap: wrap;
		align-items: center;
		gap: var(--space-sm);
		color: var(--color-text-muted);
		font-size: var(--text-body-sm);
	}

	.meta-item:not(:last-child)::after {
		content: '·';
		margin-inline-start: var(--space-sm);
	}

	.cert-badge {
		padding: 1px var(--space-sm);
		border-radius: var(--radius-xs);
		border: 1px solid var(--color-outline);
		color: var(--color-text);
		font-weight: 600;
	}

	.header-credit {
		display: flex;
		flex-direction: column;
		min-width: 0;
	}

	.header-credit-label {
		font-size: var(--text-body-sm);
		font-style: italic;
		color: var(--color-text-subtle);
	}

	.genre-list {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-xs);
		list-style: none;
		padding: 0;
	}

	.genre-chip {
		padding: var(--space-xs) var(--space-md);
		border-radius: var(--radius-full);
		background-color: var(--color-surface);
		border: 1px solid var(--color-border);
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

	.meta-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
		gap: var(--space-md);
	}

	.meta-field {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxs);
	}

	.field-label {
		font-size: var(--text-body-sm);
		color: var(--color-text-subtle);
	}

	.field-value {
		font-size: var(--text-body-md);
		color: var(--color-text);
		font-weight: 500;
	}

	.collection-card {
		display: flex;
		align-items: center;
		gap: var(--space-md);
		padding: var(--space-md);
		border-radius: var(--radius-chip);
		background-color: var(--color-surface);
		border: 1px solid var(--color-border);
	}

	.collection-card:hover {
		border-color: var(--color-primary);
	}

	.collection-thumb {
		width: 56px;
		flex-shrink: 0;
	}

	.collection-info {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxs);
	}

	.collection-kicker {
		font-size: var(--text-body-sm);
		color: var(--color-primary);
		font-weight: 700;
	}

	.collection-name {
		font-size: var(--text-title-md);
		font-weight: 700;
	}

	.season-chip {
		flex: 0 0 148px;
		scroll-snap-align: start;
		display: flex;
		flex-direction: column;
		border-radius: var(--radius-chip);
		overflow: hidden;
		background-color: var(--color-surface-elevated);
		border: 1px solid var(--color-outline-subtle);
	}

	.season-chip:hover {
		border-color: var(--color-primary);
	}

	.season-info {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxs);
		padding: var(--space-sm);
	}

	.season-title {
		font-size: var(--text-title-sm);
		font-weight: 600;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
		line-clamp: 2;
		overflow: hidden;
	}

	.season-meta {
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
	}
</style>
