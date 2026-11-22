<script lang="ts">
	import '$lib/styles/tokens.css';
	import '$lib/styles/global.css';
	import AppFooter from '$lib/components/AppFooter.svelte';
	import AppHeader from '$lib/components/AppHeader.svelte';
	import type { Snippet } from 'svelte';
	import type { LayoutData } from './$types';

	interface Props {
		data: LayoutData;
		children: Snippet;
	}

	let { data, children }: Props = $props();
</script>

<AppHeader locale={data.locale} region={data.region} />

<main id="main-content">
	{@render children()}
</main>

<AppFooter locale={data.locale} />
