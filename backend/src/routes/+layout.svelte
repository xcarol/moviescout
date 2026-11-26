<script lang="ts">
	import '$lib/styles/tokens.css';
	import '$lib/styles/global.css';
	import { afterNavigate } from '$app/navigation';
	import AppFooter from '$lib/components/core/AppFooter.svelte';
	import AppHeader from '$lib/components/core/AppHeader.svelte';
	import ConsentBanner from '$lib/components/core/ConsentBanner.svelte';
	import { initAnalytics, trackPageView } from '$lib/utils/analytics.svelte';
	import { onMount, tick, type Snippet } from 'svelte';
	import type { LayoutData } from './$types';

	interface Props {
		data: LayoutData;
		children: Snippet;
	}

	let { data, children }: Props = $props();

	onMount(() => {
		initAnalytics();
	});

	afterNavigate(({ from, to }) => {
		if (from && to) {
			tick().then(() => trackPageView(to.url, document.title));
		}
	});
</script>

<AppHeader locale={data.locale} region={data.region} />

<main id="main-content">
	{@render children()}
</main>

<AppFooter locale={data.locale} />
<ConsentBanner locale={data.locale} />
