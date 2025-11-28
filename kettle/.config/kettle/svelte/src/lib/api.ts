import { logout } from "./stores/session";
import API_URL from "@/apiUrl";

export const requestApi = async <T>(method: string, endpoint: string, body?: any): Promise<T> => {
  const response = await fetch(`${API_URL}${endpoint}`, {
    method,
    headers: {
      "Content-Type": "application/json"
    },
    body: body ? JSON.stringify(body) : undefined,
    credentials: "include"
  });

  if (response.status === 401) {
    await logout();
    throw new Error("Session expired");
  }

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`Failed to fetch: ${response.status} ${errorText}`);
  }

  const json = await response.json() as T;
  return json;
};
