<script lang="ts">
	import Sidebar from '@/components/Sidebar.svelte';
</script>

<div class="flex min-h-screen flex-row">
	<Sidebar />
	<div class="flex-1 p-3 md:p-6">
		<slot />
	</div>
</div>
