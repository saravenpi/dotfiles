import type { ServerResponse } from "./types"

export const SUCCESS_RESPONSE = (message: string): ServerResponse => ({ success: true, message: message, error: "" })
export const ERROR_RESPONSE = (message: string): ServerResponse => ({ success: false, message: "", error: message })
