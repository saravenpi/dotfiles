<script lang="ts">
	import { toast } from "svelte-sonner";
	import { Button } from "$lib/components/ui/button";
    import type { ServerResponse } from "$lib/types";

	async function handleLogout() {
		try {
			const response = await fetch("/api/logout", { method: "POST" });
			const result: ServerResponse = await response.json();

			if (result.success) {
				toast.success(result.message);
				window.location.href = "/";
			} else {
				toast.error(result.error);
			}
		} catch (error) {
			toast.error("An error occurred. Please try again later !");
		}
	}
</script>

<Button on:click={handleLogout} class="bg-red-500">Logout</Button>
