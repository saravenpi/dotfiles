<script lang="ts">
	import LogoutButton from "$lib/components/LogoutButton.svelte";
	import type { User } from "$lib/types";
	export let data;
	let user: User | undefined = data.user as User;
	console.log(user);
</script>

<div
	class="flex flex-col gap-6 justify-center place-items-center w-full h-screen"
>
	<div class="p-10 border rounded flex flex-col gap-6">
		{#if user}
			<span class="text-lg">
				<span class="font-semibold">Username</span>: {user.username}
			</span>
			<span class="text-lg">
				<span class="font-semibold">Email</span>: {user.email}
			</span>
		{/if}
	</div>
	<LogoutButton />
</div>
