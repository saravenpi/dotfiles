import PocketBase from "pocketbase";
import { PB_URL } from "$env/static/private"
import type { PBUser, ServerResponse, User } from '$lib/types'
import type { RequestEvent } from "./$types";
import { storeUserAuthCookie } from "$lib/auth";
import { ERROR_RESPONSE, SUCCESS_RESPONSE } from "$lib/response";

const client = new PocketBase(PB_URL);

export const actions = {
	register: async (event: RequestEvent): Promise<ServerResponse> => {
		const data = await event.request.formData();
		const email: string | undefined = data.get('email')?.toString()
		const username: string | undefined  = data.get('username')?.toString()
		const password: string | undefined  = data.get('password')?.toString()
		const passwordConfirm: string | undefined  = data.get('passwordConfirm')?.toString()

		if (!email || !password || !username || !passwordConfirm)
			return ERROR_RESPONSE("Missing fields")
		if (passwordConfirm != password)
			return ERROR_RESPONSE("Passwords do not match")
		if (password.length < 8)
			return ERROR_RESPONSE("Password minimum length is 8")

		const newUser: PBUser = {
			username: username,
			email: email,
			password: password,
			passwordConfirm: passwordConfirm,
			emailVisibility: true,
		}

		try {
			const user: User | null = await client.collection("users").create(newUser)

			if (!user)
				return ERROR_RESPONSE("Failed to create user")
			event.cookies = storeUserAuthCookie(event, user)
			return SUCCESS_RESPONSE("User created successfully")
		} catch (error) {
			console.log(error)
			return ERROR_RESPONSE("User creation failed")
		}

	}
}

