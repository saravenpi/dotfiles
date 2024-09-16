<script>
	import Button from "$lib/components/ui/button/button.svelte";
</script>

<div
	class="w-full h-screen flex flex-col justify-center place-items-center"
	id="bg"
>
	<div
		class="rounded flex flex-col gap-6 p-6 bg-transparent backdrop-blur-lg w-[300px]"
	>
		<span class="text-3xl text-white">Welcome</span>
		<Button href="/login">Login</Button>
		<Button href="/register">Register</Button>
	</div>
</div>

<style>
	#bg {
		background-image: url("florian.jpg");
		background-size: cover;
	}
</style>
