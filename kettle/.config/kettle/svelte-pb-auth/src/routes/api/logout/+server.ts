import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import type { ServerResponse } from '$lib/types';
import { logout } from '$lib/auth'

export const POST: RequestHandler = async ({ cookies }) => {
	const result: ServerResponse = logout(cookies);
	const responseStatusCode: number = (result.success) ? 200 : 500

	return json(result, { status: responseStatusCode });
}
