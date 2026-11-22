<script lang="ts">
	import { IMDB_WEB_URL, TMDB_LOGO_ASSET, TMDB_WEB_URL } from '$lib/constants/urls';
	import type { ExternalLinks as ExternalLinksData } from '$lib/types/tmdb';

	interface Props {
		mediaType: 'movie' | 'tv' | 'person' | 'collection';
		id: number;
		links?: ExternalLinksData;
		heading: string;
	}

	let { mediaType, id, links = {}, heading }: Props = $props();

	interface LinkItem {
		label: string;
		href: string;
		iconAsset?: string;
		isGlobe?: boolean;
	}

	const items = $derived.by((): LinkItem[] => {
		const list: LinkItem[] = [
			{
				label: 'The Movie Database (TMDB)',
				href: `${TMDB_WEB_URL}/${mediaType}/${id}`,
				iconAsset: TMDB_LOGO_ASSET
			}
		];

		if (links.imdbId) {
			const imdbSegment = mediaType === 'person' ? 'name' : 'title';
			list.push({
				label: 'IMDb',
				href: `${IMDB_WEB_URL}/${imdbSegment}/${links.imdbId}`,
				iconAsset: '/assets/imdb-logo.png'
			});
		}

		if (links.wikidataId) {
			list.push({
				label: 'Wikidata',
				href: `https://www.wikidata.org/wiki/${links.wikidataId}`,
				iconAsset: '/assets/wikidata.png'
			});
		}

		if (links.facebookId) {
			list.push({
				label: 'Facebook',
				href: `https://facebook.com/${links.facebookId}`,
				iconAsset: '/assets/facebook.png'
			});
		}

		if (links.instagramId) {
			list.push({
				label: 'Instagram',
				href: `https://instagram.com/${links.instagramId}`,
				iconAsset: '/assets/instagram.png'
			});
		}

		if (links.twitterId) {
			list.push({
				label: 'X',
				href: `https://x.com/${links.twitterId}`,
				iconAsset: '/assets/X.png'
			});
		}

		if (links.tiktokId) {
			list.push({
				label: 'TikTok',
				href: `https://tiktok.com/@${links.tiktokId}`,
				iconAsset: '/assets/tiktok.png'
			});
		}

		if (links.youtubeId) {
			list.push({
				label: 'YouTube',
				href: `https://youtube.com/${links.youtubeId}`,
				iconAsset: '/assets/youtube.png'
			});
		}

		if (links.homepage) {
			list.push({
				label: 'Website',
				href: links.homepage,
				isGlobe: true
			});
		}

		return list;
	});
</script>

<section class="external-links" aria-label={heading}>
	<h2 class="section-title">{heading}</h2>
	<div class="links-wrap">
		{#each items as item (item.href)}
			<a
				class="link-chip"
				href={item.href}
				target="_blank"
				rel="noopener noreferrer"
				aria-label={item.label}
				title={item.label}
			>
				{#if item.iconAsset}
					<img src={item.iconAsset} alt={item.label} height="20" />
				{:else if item.isGlobe}
					<svg
						viewBox="0 0 24 24"
						width="20"
						height="20"
						fill="none"
						stroke="currentColor"
						stroke-width="2"
						aria-hidden="true"
					>
						<circle cx="12" cy="12" r="10" />
						<path d="M2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
					</svg>
				{/if}
			</a>
		{/each}
	</div>
</section>

<style>
	.external-links {
		display: flex;
		flex-direction: column;
		gap: var(--space-sm);
	}

	.section-title {
		font-size: var(--text-title-md);
		font-weight: 700;
	}

	.links-wrap {
		display: flex;
		flex-wrap: wrap;
		gap: var(--space-sm);
	}

	.link-chip {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		min-width: 36px;
		min-height: 36px;
		padding: var(--space-xs) var(--space-sm);
		border-radius: var(--radius-sm);
		background-color: var(--color-surface);
		border: 1px solid var(--color-border);
		color: var(--color-text-muted);
	}

	.link-chip:hover {
		border-color: var(--color-primary);
		color: var(--color-text);
	}

	.link-chip img {
		height: 20px;
		width: auto;
		object-fit: contain;
	}
</style>
