import { type SessionType } from "@/types";
import storage from '@/storage'

export const sessionStore = storage<SessionType>("session", {
  user: undefined,
})


export async function load(): Promise<void> {
  try {
    console.log("Loading user from session store");
  } catch (error) {
    console.error("Error loading user:", error);
  }
}
export async function login(email: string, password: string): Promise<boolean> {
  return true
}

export async function register(email: string, firstName: string, lastName: string, password: string): Promise<boolean> {
  return true
}

export async function logout(): Promise<void> {
  sessionStore.update((user: SessionType) => {
    user = {
      user: undefined,
    }
    return user
  })
  localStorage.clear();
}

export default sessionStore;
