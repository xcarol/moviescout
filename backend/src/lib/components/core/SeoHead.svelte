<script lang="ts">
	import { APP_NAME } from '$lib/constants/app';
	import { DEFAULT_OG_IMAGE_URL, SITE_URL } from '$lib/constants/urls';
	import { LOCALE_OG_MAP, type SupportedLocale } from '$lib/i18n';

	interface Props {
		title: string;
		description: string;
		canonicalPath: string;
		locale: SupportedLocale;
		ogType?: 'website' | 'video.movie' | 'video.tv_show' | 'video.episode' | 'profile';
		ogImage?: string | null;
		jsonLd?: Record<string, unknown> | Array<Record<string, unknown>>;
		noindex?: boolean;
	}

	let {
		title,
		description,
		canonicalPath,
		locale,
		ogType = 'website',
		ogImage = null,
		jsonLd,
		noindex = false
	}: Props = $props();

	const canonicalUrl = $derived(`${SITE_URL}${canonicalPath.startsWith('/') ? canonicalPath : `/${canonicalPath}`}`);
	const resolvedImage = $derived(ogImage && ogImage.trim() ? ogImage : DEFAULT_OG_IMAGE_URL);
	const ogLocale = $derived(LOCALE_OG_MAP[locale] ?? 'en_US');
	const serializedJsonLd = $derived(
		jsonLd ? JSON.stringify(jsonLd).replace(/</g, '\\u003c') : ''
	);
</script>

<svelte:head>
	<title>{title}</title>
	<meta name="description" content={description} />
	<link rel="canonical" href={canonicalUrl} />
	{#if noindex}
		<meta name="robots" content="noindex, nofollow" />
	{/if}

	<meta property="og:site_name" content={APP_NAME} />
	<meta property="og:type" content={ogType} />
	<meta property="og:title" content={title} />
	<meta property="og:description" content={description} />
	<meta property="og:url" content={canonicalUrl} />
	<meta property="og:image" content={resolvedImage} />
	<meta property="og:locale" content={ogLocale} />

	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:title" content={title} />
	<meta name="twitter:description" content={description} />
	<meta name="twitter:image" content={resolvedImage} />

	{#if serializedJsonLd}
		<!-- eslint-disable-next-line svelte/no-at-html-tags -->
		{@html `<script type="application/ld+json">${serializedJsonLd}</script>`}
	{/if}
</svelte:head>
