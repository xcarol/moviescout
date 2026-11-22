<script lang="ts">
	import { tw, type SupportedLocale } from '$lib/i18n';
	import ExpandableText from './ExpandableText.svelte';

	interface Props {
		people: Array<{ id: number; name: string }>;
		locale: SupportedLocale;
		useEllipsis?: boolean;
	}

	let { people, locale, useEllipsis = false }: Props = $props();
</script>

{#snippet namesList()}
	{#each people as person, i (person.id)}<a class="credit-link" href={`/person/${person.id}`}>{person.name}</a>{#if i < people.length - 1},{' '}{/if}{/each}
{/snippet}

{#if people.length > 0}
	{#if useEllipsis}
		<p class="clickable-names is-ellipsis">{@render namesList()}</p>
	{:else}
		<ExpandableText
			maxLines={1}
			resetKey={people.map((person) => person.id).join(',')}
			moreLabel={tw(locale, 'showMore')}
			lessLabel={tw(locale, 'showLess')}
		>
			{@render namesList()}
		</ExpandableText>
	{/if}
{/if}

<style>
	.clickable-names {
		color: var(--color-text);
		font-size: var(--text-body-md);
		line-height: 1.6;
	}

	.clickable-names.is-ellipsis {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.credit-link {
		font-weight: 700;
	}

	.credit-link:hover {
		color: var(--color-primary);
		text-decoration: underline;
	}
</style>
