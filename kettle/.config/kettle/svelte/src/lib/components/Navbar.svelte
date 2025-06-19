<script lang="ts">
	import sessionStore from '@/stores/session';
	import Button from './ui/button/button.svelte';
	import GalleryVerticalEndIcon from '@lucide/svelte/icons/gallery-vertical-end';

	$: session = $sessionStore;
</script>

<div
	class="text-foreground flex w-full items-center justify-between bg-transparent p-4 backdrop-blur-md md:p-10"
>
	<a href="/" class="flex items-center gap-2 font-medium">
		<div
			class="bg-primary text-primary-foreground flex size-6 items-center justify-center rounded-md"
		>
			<GalleryVerticalEndIcon class="size-4" />
		</div>
		Acme Inc.
	</a>
	<nav class="space-x-4">
		{#if session?.user}
			<Button href="/dashboard">Open App</Button>
		{:else}
			<Button href="/login">Login</Button>
			<Button href="/register" variant="secondary">Register</Button>
		{/if}
	</nav>
</div>
