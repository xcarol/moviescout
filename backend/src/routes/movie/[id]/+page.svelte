<script lang="ts">
	import SeoHead from '$lib/components/SeoHead.svelte';
	import TitleDetailView from '$lib/components/TitleDetailView.svelte';
	import type { PageData } from './$types';

	interface Props {
		data: PageData;
	}

	let { data }: Props = $props();
</script>

<SeoHead
	title={data.seo.title}
	description={data.seo.description}
	canonicalPath={data.seo.canonicalPath}
	ogType={data.seo.ogType}
	ogImage={data.seo.ogImage}
	locale={data.locale}
	jsonLd={data.seo.jsonLd}
/>

<TitleDetailView details={data.details} locale={data.locale} />
