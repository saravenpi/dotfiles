export type PBUser = {
	username: string,
	email: string,
	emailVisibility: boolean
	password: string,
	passwordConfirm: string,
}

export type User = {
	username: string,
	password: string,
	email: string
}

export type ServerResponse = {
	success: boolean,
	message: string,
	error: string
}
