<script lang="ts">
	import AppPromoBanner from '$lib/components/AppPromoBanner.svelte';
	import ExpandableText from '$lib/components/ExpandableText.svelte';
	import ExternalLinks from '$lib/components/ExternalLinks.svelte';
	import HorizontalRail from '$lib/components/HorizontalRail.svelte';
	import MediaCarousel from '$lib/components/MediaCarousel.svelte';
	import SeoHead from '$lib/components/SeoHead.svelte';
	import TitleChip from '$lib/components/TitleChip.svelte';
	import { TMDB_IMAGE_SIZE } from '$lib/constants/urls';
	import { t, translateDepartment, translateJob, tw } from '$lib/i18n';
	import type { PageData } from './$types';

	interface Props {
		data: PageData;
	}

	let { data }: Props = $props();
	const person = $derived(data.person);

	const profileImages = $derived.by(() => {
		if (person.images.length > 0) return person.images.slice(0, 10);
		return person.profilePath ? [person.profilePath] : [];
	});
</script>

<SeoHead
	title={data.seo.title}
	description={data.seo.description}
	canonicalPath={data.seo.canonicalPath}
	ogType="profile"
	ogImage={data.seo.ogImage}
	locale={data.locale}
	jsonLd={data.seo.jsonLd}
/>

<article class="person-page content-container">
	<header class="person-header">
		<div class="portrait-col">
			<MediaCarousel
				images={profileImages}
				fallbackType="person"
				alt={person.name}
				aspectRatio="2 / 3"
				size={TMDB_IMAGE_SIZE.w500}
				firstPriority="high"
				label={t(data.locale, 'gallery')}
				radius="var(--radius-chip)"
			/>
		</div>

		<div class="info-col">
			{#if person.knownForDepartment}
				<span class="dept-pill">
					{translateDepartment(person.knownForDepartment, data.locale)}
				</span>
			{/if}

			<h1 class="person-name">{person.name}</h1>

			<dl class="bio-meta">
				{#if person.birthday}
					<div class="meta-item">
						<dt>{t(data.locale, 'birthDate')}</dt>
						<dd>{person.birthday}</dd>
					</div>
				{/if}
				{#if person.deathday}
					<div class="meta-item">
						<dt>{t(data.locale, 'deathDate')}</dt>
						<dd>{person.deathday}</dd>
					</div>
				{/if}
				{#if person.placeOfBirth}
					<div class="meta-item">
						<dt>{t(data.locale, 'placeOfBirth')}</dt>
						<dd>{person.placeOfBirth}</dd>
					</div>
				{/if}
			</dl>
		</div>
	</header>

	{#if person.biography}
		<section class="section-block" aria-labelledby="bio-heading">
			<h2 id="bio-heading" class="section-title">{tw(data.locale, 'biography')}</h2>
			<ExpandableText
				text={person.biography}
				maxLines={8}
				moreLabel={tw(data.locale, 'showMore')}
				lessLabel={tw(data.locale, 'showLess')}
			/>
		</section>
	{/if}

	<section class="section-block">
		<AppPromoBanner locale={data.locale} />
	</section>

	{#if person.castCredits.length > 0}
		<section class="section-block">
			<HorizontalRail title={`${t(data.locale, 'cast')} (${person.castCredits.length})`}>
				{#each person.castCredits.slice(0, 24) as credit (`cast-${credit.mediaType}-${credit.id}`)}
					<TitleChip item={credit} subtitle={credit.role} />
				{/each}
			</HorizontalRail>
		</section>
	{/if}

	{#if person.crewCredits.length > 0}
		<section class="section-block">
			<HorizontalRail title={`${t(data.locale, 'crew')} (${person.crewCredits.length})`}>
				{#each person.crewCredits.slice(0, 24) as credit (`crew-${credit.mediaType}-${credit.id}`)}
					<TitleChip
						item={credit}
						subtitle={credit.role ? translateJob(credit.role, data.locale) : ''}
					/>
				{/each}
			</HorizontalRail>
		</section>
	{/if}

	{#if person.taggedImages.length > 0}
		<section class="section-block" aria-labelledby="tagged-heading">
			<h2 id="tagged-heading" class="section-title">{tw(data.locale, 'taggedImages')}</h2>
			<MediaCarousel
				images={person.taggedImages.slice(0, 10)}
				fallbackType="backdrop"
				alt={person.name}
				aspectRatio="16 / 9"
				size={TMDB_IMAGE_SIZE.w780}
				firstPriority="normal"
				label={tw(data.locale, 'taggedImages')}
				radius="var(--radius-chip)"
			/>
		</section>
	{/if}

	<section class="section-block">
		<ExternalLinks
			mediaType="person"
			id={person.id}
			links={person.externalLinks}
			heading={tw(data.locale, 'externalLinks')}
		/>
	</section>
</article>

<style>
	.person-page {
		display: flex;
		flex-direction: column;
		gap: var(--space-xl);
		padding-block: var(--space-lg);
	}

	.person-header {
		display: grid;
		grid-template-columns: 180px minmax(0, 1fr);
		gap: var(--space-xl);
		align-items: start;
	}

	@media (max-width: 600px) {
		.person-header {
			grid-template-columns: 130px minmax(0, 1fr);
			gap: var(--space-md);
		}
	}

	.info-col {
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
		min-width: 0;
	}

	.dept-pill {
		align-self: flex-start;
		padding: var(--space-xxs) var(--space-sm);
		border-radius: var(--radius-full);
		background-color: var(--color-surface-elevated);
		color: var(--color-primary);
		font-size: var(--text-body-sm);
		font-weight: 700;
	}

	.person-name {
		font-size: clamp(1.4rem, 2.5vw, 2.1rem);
		font-weight: 800;
		line-height: 1.2;
	}

	.bio-meta {
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
		margin: 0;
	}

	.meta-item {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxs);
	}

	.meta-item dt {
		font-size: var(--text-body-sm);
		color: var(--color-text-subtle);
	}

	.meta-item dd {
		margin: 0;
		font-size: var(--text-body-md);
		color: var(--color-text);
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
</style>
