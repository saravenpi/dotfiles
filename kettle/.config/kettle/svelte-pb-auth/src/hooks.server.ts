import { authUser } from '$lib/auth';
import { redirect, type Handle } from '@sveltejs/kit';
import { sequence } from '@sveltejs/kit/hooks';

const NON_AUTH_PAGES = [
	"/",
	"/login",
	"/register"
]
export const authentication: Handle = async ({ event, resolve }) => {
	// auth
	event.locals.user = authUser(event);

	// route safety
	if (!event.locals.user && (NON_AUTH_PAGES.includes(event.url.pathname))) {
		const response = await resolve(event);
		return response;
	}
	if (!event.locals.user && event.url.pathname !== '/')
		throw redirect(303, '/');
	if (event.locals.user && (NON_AUTH_PAGES.includes(event.url.pathname)))
		throw redirect(303, '/dashboard');

	// hooks sequence
	const response = await resolve(event);
	return response;
}

export const handle = sequence(authentication)
