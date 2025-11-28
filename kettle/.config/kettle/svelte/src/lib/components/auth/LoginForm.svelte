<script lang="ts">
	import { Label } from '$lib/components/ui/label/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { Button } from '$lib/components/ui/button/index.js';
	import { cn, type WithElementRef } from '$lib/utils.js';
	import type { HTMLFormAttributes } from 'svelte/elements';
	let {
		ref = $bindable(null),
		class: className,
		...restProps
	}: WithElementRef<HTMLFormAttributes> = $props();
	const id = $props.id();
</script>

<form class={cn('flex flex-col gap-6', className)} bind:this={ref} {...restProps}>
	<div class="flex flex-col items-center gap-2 text-center">
		<h1 class="text-2xl font-bold">Login to your account</h1>
		<p class="text-muted-foreground text-sm text-balance">
			Enter your email below to login to your account
		</p>
	</div>
	<div class="grid gap-6">
		<div class="grid gap-3">
			<Label for="email-{id}">Email</Label>
			<Input id="email-{id}" type="email" placeholder="m@example.com" required />
		</div>
		<div class="grid gap-3">
			<div class="flex items-center">
				<Label for="password-{id}">Password</Label>
				<a href="##" class="ml-auto text-sm underline-offset-4 hover:underline">
					Forgot your password?
				</a>
			</div>
			<Input id="password-{id}" type="password" required />
		</div>
		<Button type="submit" class="w-full">Login</Button>
		<div
			class="after:border-border relative text-center text-sm after:absolute after:inset-0 after:top-1/2 after:z-0 after:flex after:items-center after:border-t"
		>
			<span class="bg-background text-muted-foreground relative z-10 px-2"> Or continue with </span>
		</div>
		<Button variant="outline" class="w-full">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="mr-2 h-4 w-4">
				<path
					d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
					fill="#4285F4"
				/>
				<path
					d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
					fill="#34A853"
				/>
				<path
					d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
					fill="#FBBC05"
				/>
				<path
					d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
					fill="#EA4335"
				/>
			</svg>
			Login with Google
		</Button>
	</div>
	<div class="text-center text-sm">
		Don&apos;t have an account?
		<a href="/register" class="underline underline-offset-4"> Register </a>
	</div>
</form>
