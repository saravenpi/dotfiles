<script lang="ts">
	import { pages } from '@/pages';
	import Icon from '@iconify/svelte';
</script>

<!-- Sidebar.svelte -->
<div class="bg-secondary text-secondary-foreground h-screen w-64 p-4">
	<h2 class="mb-4 text-xl font-bold">Sidebar</h2>
	<ul class="space-y-2">
		{#each pages as page}
			<li>
				<a href={page.url} class="block rounded p-2 hover:bg-neutral-500 hover:text-white">
					<Icon icon={page.icon} class="mr-2 inline-block" />
					{page.name}
				</a>
			</li>
		{/each}
	</ul>
</div>
