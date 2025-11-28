import type { Cookies, RequestEvent } from "@sveltejs/kit";
import type { ServerResponse, User } from "$lib/types";
import { ERROR_RESPONSE, SUCCESS_RESPONSE } from "$lib/response";

export const storeUserAuthCookie = (event: RequestEvent, user: User) => {
	const serializedObject = JSON.stringify(user);
	event.cookies.set('auth', serializedObject, {
		path: '/',
		httpOnly: true,
		sameSite: 'strict',
		maxAge: 60 * 60 * 24 * 7, // 1 week
	});
	return event.cookies
}

export const authUser = (event: RequestEvent): User | null => {
	try {
		const authCookie = event.cookies.get('auth');

		if (authCookie) {
			const userObject: User = JSON.parse(authCookie);
			return userObject;
		} else {
			return null;
		}
	} catch (_) {
		return null;
	}
}

export const logout = (eventOrCookies: RequestEvent | Cookies): ServerResponse => {
	try {
		const cookies = 'cookies' in eventOrCookies ? eventOrCookies.cookies : eventOrCookies;
		cookies.delete('auth', { path: '/' });
		return SUCCESS_RESPONSE("Logged out successfully");
	} catch (error) {
		console.error('Logout error:', error);
		return ERROR_RESPONSE("Failed to log out");
	}
}
