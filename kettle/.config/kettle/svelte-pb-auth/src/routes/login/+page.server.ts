import PocketBase from "pocketbase";
import { PB_URL } from '$env/static/private'
import type { ServerResponse, User } from "$lib/types";
import { storeUserAuthCookie } from "$lib/auth";
import { ERROR_RESPONSE, SUCCESS_RESPONSE } from "$lib/response";
import type { RequestEvent } from "./$types";

const client = new PocketBase(PB_URL);

export const actions = {
	login: async (event: RequestEvent): Promise<ServerResponse> => {
		const data = await event.request.formData();
		const email: string | undefined = data.get('email')?.toString()
		const password: string | undefined = data.get('password')?.toString()

		if (!email || !password)
			return ERROR_RESPONSE("Missing fields")
		try {
			const authData: any = await client.collection("users").authWithPassword(email, password)
			const user: User | null = authData.record

			if (!user)
				return ERROR_RESPONSE("Failed to login")
			event.cookies = storeUserAuthCookie(event, user)
			return SUCCESS_RESPONSE("User login successful")
		} catch (error: any) {
			return ERROR_RESPONSE("User login failed")
		}

	}
}
