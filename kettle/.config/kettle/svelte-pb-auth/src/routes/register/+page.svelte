<script lang="ts">
	import { enhance } from "$app/forms";
	import { Input } from "$lib/components/ui/input";
	import { Button } from "$lib/components/ui/button/";
	import { toast } from "svelte-sonner";

	let email: string = "";
	let username: string = "";
	let password: string = "";
	let passwordConfirm: string = "";

	function handleRegister(result: any) {
		if (result.data.success) {
			toast.success(result.data.message);
			window.location.href = "/dashboard";
		} else {
			toast.error(result.data.error);
		}
	}
</script>

<div class="flex w-full justify-center place-items-center h-screen" id="bg">
	<div class="rounded w-[500px] p-10 bg-transparent backdrop-blur-xl">
		<div class="text-3xl mb-6 text-white">Register</div>
		<form
			action="?/register"
			method="POST"
			use:enhance={() => {
				return ({ result }) => {
					handleRegister(result);
				};
			}}
		>
			<div class="flex flex-col gap-6">
				<Input
					type="email"
					name="email"
					value={email}
					placeholder="Email"
				/>
				<Input
					type="text"
					name="username"
					value={username}
					placeholder="Username"
				/>
				<Input
					type="password"
					name="password"
					value={password}
					placeholder="Password"
				/>
				<Input
					type="password"
					name="passwordConfirm"
					value={passwordConfirm}
					placeholder="Password confirm"
				/>
				<Button type="submit">Register</Button>
				<span class="text-lg text-white">
					Do you want to <a
						class="text-white font-semibold underline"
						href="/login"
					>
						Login
					</a> instead?
				</span>
			</div>
		</form>
	</div>
</div>

<style>
	#bg {
		background-image: url("florian.jpg");
		background-size: cover;
	}
</style>
