<script lang="ts">
	import SeoHead from '$lib/components/core/SeoHead.svelte';
	import { APP_NAME } from '$lib/constants/app';
	import { GITHUB_REPO_URL, GOOGLE_PLAY_URL } from '$lib/constants/urls';
	import { tw } from '$lib/i18n';
	import type { PageData } from './$types';

	interface Props {
		data: PageData;
	}

	let { data }: Props = $props();

	const features = $derived([
		{
			title: tw(data.locale, 'landingFeatureAvailabilityTitle'),
			desc: tw(data.locale, 'landingFeatureAvailabilityDesc')
		},
		{
			title: tw(data.locale, 'landingFeatureNotificationsTitle'),
			desc: tw(data.locale, 'landingFeatureNotificationsDesc')
		},
		{
			title: tw(data.locale, 'landingFeatureOrganizeTitle'),
			desc: tw(data.locale, 'landingFeatureOrganizeDesc')
		},
		{
			title: tw(data.locale, 'landingFeatureDetailsTitle'),
			desc: tw(data.locale, 'landingFeatureDetailsDesc')
		}
	]);
</script>

<SeoHead
	title={data.seo.title}
	description={data.seo.description}
	canonicalPath={data.seo.canonicalPath}
	ogImage={data.seo.ogImage}
	locale={data.locale}
	jsonLd={data.seo.jsonLd}
/>

<section class="landing content-container">
	<div class="hero-card">
		<img
			src="/imatge-destacada.png"
			alt={APP_NAME}
			class="hero-image"
			fetchpriority="high"
		/>
	</div>

	<div class="hero-copy">
		<h1 class="motto">{tw(data.locale, 'landingMotto')}</h1>
		<p class="subtitle">{tw(data.locale, 'landingSubtitle')}</p>

		<div class="cta-row">
			<a
				class="btn-primary"
				href={GOOGLE_PLAY_URL}
				target="_blank"
				rel="noopener noreferrer"
			>
				<svg viewBox="0 0 512 512" width="20" height="20" fill="currentColor" aria-hidden="true">
					<path
						d="M325.3 234.3L104.6 13l280.8 161.2-60.1 60.1zM47 0C34 6.8 25.3 19.2 25.3 35.3v441.3c0 16.1 8.7 28.5 21.7 35.3l256.6-256L47 0zm425.2 225.6l-58.9-34.1-65.7 64.5 65.7 64.5 60.1-34.1c18-14.3 18-46.5-1.2-60.8zM104.6 499l280.8-161.2-60.1-60.1L104.6 499z"
					/>
				</svg>
				<span>{tw(data.locale, 'getItOnGooglePlay')}</span>
			</a>

			<a
				class="btn-secondary"
				href={GITHUB_REPO_URL}
				target="_blank"
				rel="noopener noreferrer"
			>
				<svg viewBox="0 0 98 96" width="20" height="20" fill="currentColor" aria-hidden="true">
					<path
						fill-rule="evenodd"
						clip-rule="evenodd"
						d="M48.854 0C21.839 0 0 22 0 49.217c0 21.756 13.993 40.172 33.405 46.69 2.427.49 3.316-1.059 3.316-2.362 0-1.141-.08-5.052-.08-9.127-13.59 2.934-16.42-5.867-16.42-5.867-2.184-5.704-5.42-7.17-5.42-7.17-4.448-3.015.324-3.015.324-3.015 4.934.326 7.523 5.052 7.523 5.052 4.367 7.496 11.404 5.378 14.235 4.074.404-3.178 1.699-5.378 3.074-6.6-10.839-1.141-22.243-5.378-22.243-24.283 0-5.378 1.94-9.778 5.014-13.2-.485-1.222-2.184-6.275.486-13.038 0 0 4.125-1.304 13.426 5.052a46.97 46.97 0 0 1 12.214-1.63c4.125 0 8.33.571 12.213 1.63 9.302-6.356 13.427-5.052 13.427-5.052 2.67 6.763.97 11.816.485 13.038 3.155 3.422 5.015 7.822 5.015 13.2 0 18.905-11.404 23.06-22.324 24.283 1.78 1.548 3.316 4.481 3.316 9.126 0 6.6-.08 11.897-.08 13.526 0 1.304.89 2.853 3.316 2.364 19.412-6.52 33.405-24.935 33.405-46.691C97.707 22 75.868 0 48.854 0z"
					/>
				</svg>
				<span>{tw(data.locale, 'viewOnGithub')}</span>
			</a>
		</div>
	</div>

	<ul class="feature-grid">
		{#each features as feat (feat.title)}
			<li class="feature-card">
				<span class="feature-check" aria-hidden="true">&#10003;</span>
				<div>
					<h2 class="feature-title">{feat.title}</h2>
					<p class="feature-desc">{feat.desc}</p>
				</div>
			</li>
		{/each}
	</ul>
</section>

<style>
	.landing {
		display: flex;
		flex-direction: column;
		gap: var(--space-xxl);
		padding-block: var(--space-xl);
	}

	.hero-card {
		border-radius: var(--radius-chip);
		overflow: hidden;
		border: 1px solid var(--color-border);
		background-color: var(--color-surface);
	}

	.hero-image {
		width: 100%;
		height: auto;
		display: block;
	}

	.hero-copy {
		display: flex;
		flex-direction: column;
		align-items: center;
		text-align: center;
		gap: var(--space-lg);
	}

	.motto {
		font-size: clamp(1.85rem, 4vw, 2.75rem);
		font-weight: 800;
		letter-spacing: -0.02em;
		line-height: 1.15;
	}

	.subtitle {
		max-width: 640px;
		font-size: var(--text-body-lg);
		color: var(--color-text-muted);
		line-height: 1.6;
	}

	.cta-row {
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		gap: var(--space-md);
	}

	.btn-primary,
	.btn-secondary {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: var(--space-sm);
		min-height: 44px;
		padding: var(--space-sm) var(--space-xl);
		border-radius: var(--radius-sm);
		font-weight: 700;
		font-size: var(--text-body-md);
	}

	.btn-primary {
		background-color: var(--color-primary);
		color: var(--color-on-primary);
	}

	.btn-primary:hover {
		background-color: var(--color-primary-hover);
	}

	.btn-secondary {
		background-color: var(--color-surface);
		color: var(--color-text);
		border: 1px solid var(--color-outline);
	}

	.btn-secondary:hover {
		border-color: var(--color-primary);
	}

	.feature-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
		gap: var(--space-lg);
		list-style: none;
		padding: 0;
	}

	.feature-card {
		display: flex;
		align-items: flex-start;
		gap: var(--space-md);
		padding: var(--space-lg);
		border-radius: var(--radius-chip);
		background-color: var(--color-surface);
		border: 1px solid var(--color-border);
	}

	.feature-check {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 24px;
		height: 24px;
		border-radius: var(--radius-full);
		background-color: var(--color-surface-elevated);
		color: var(--color-primary);
		font-weight: 800;
		flex-shrink: 0;
	}

	.feature-title {
		font-size: var(--text-title-md);
		font-weight: 700;
		margin-block-end: var(--space-xs);
	}

	.feature-desc {
		font-size: var(--text-body-sm);
		color: var(--color-text-muted);
		line-height: 1.5;
	}
</style>
