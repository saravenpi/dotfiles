import { writable, type Writable, get } from "svelte/store";
import API_URL from "@/apiUrl";

import type { WebSocketMessage } from "./types";
import { handleWebSocketMessage } from "./websocketMessageHandler";

/**
 * Store that always contains the active WebSocket instance (or `null`).
 */
export const ws: Writable<WebSocket | null> = writable(null);

/**
 * Store streaming every message pushed by the server.
 */
export const messages = writable<WebSocketMessage[]>([]);

// ────────────────────────────────────────────────────────────────────────────────
// Re‑connection strategy parameters
// ────────────────────────────────────────────────────────────────────────────────
const RECONNECT_DELAY = 3_000;       // milliseconds between retries
const MAX_RETRIES: number | null = 5; // null ⇒ retry forever

let retryCount = 0;
let keepAliveTimer: ReturnType<typeof setInterval> | null = null;

// ────────────────────────────────────────────────────────────────────────────────
// Low‑level helpers
// ────────────────────────────────────────────────────────────────────────────────

const fetchToken = async (): Promise<string> => {
  const res = await fetch(`${API_URL}/auth/ws-token`, {
    credentials: "include",
  });
  const { token } = await res.json();
  if (!token) throw new Error("No token received from server");
  return token;
};

const buildSocket = async (): Promise<WebSocket> => {
  const token = await fetchToken();
  return new WebSocket(`${API_URL}/ws?token=${token}`);
};

const startKeepAlive = (socket: WebSocket) => {
  stopKeepAlive();
  keepAliveTimer = setInterval(() => {
    if (socket.readyState === WebSocket.OPEN) {
      socket.send(JSON.stringify({ type: "ping" }));
    }
  }, 20_000); // every 20 s
};

const stopKeepAlive = () => {
  if (keepAliveTimer) clearInterval(keepAliveTimer);
  keepAliveTimer = null;
};

const attemptReconnect = async () => {
  if (MAX_RETRIES !== null && retryCount >= MAX_RETRIES) {
    console.error("Max WebSocket reconnection attempts reached");
    ws.set(null);
    return;
  }

  retryCount += 1;
  console.info(
    `Reconnecting in ${RECONNECT_DELAY}ms (attempt ${retryCount}/${MAX_RETRIES ?? "∞"
    })`,
  );
  ws.set(null);

  setTimeout(async () => {
    try {
      await connect();
    } catch (err) {
      console.error("Reconnection failed:", err);
      attemptReconnect();
    }
  }, RECONNECT_DELAY);
};

const wireSocket = (socket: WebSocket) => {
  socket.addEventListener("open", () => {
    console.log("WebSocket connection established");
    retryCount = 0;
    startKeepAlive(socket);
  });

  socket.addEventListener("close", () => {
    console.warn("WebSocket closed");
    stopKeepAlive();
    attemptReconnect();
  });

  socket.addEventListener("error", (evt) => {
    console.error("WebSocket error", evt);
    socket.close();
  });

  socket.addEventListener("message", (evt) => {
    const data: WebSocketMessage = JSON.parse(evt.data);
    messages.update((m) => [...m, data]);
    handleWebSocketMessage(data)
  });
};

// ────────────────────────────────────────────────────────────────────────────────
// Public API
// ────────────────────────────────────────────────────────────────────────────────

/**
 * Creates a new WebSocket connection or returns the already‑open instance.
 */
export const connect = async (): Promise<WebSocket> => {
  const current = get(ws);
  if (current && current.readyState === WebSocket.OPEN) return current;

  const socket = await buildSocket();
  wireSocket(socket);
  ws.set(socket);
  return socket;
};

/**
 * Returns `true` iff the underlying socket is currently `OPEN`.
 */
export const isAlive = (): boolean => {
  const current = get(ws);
  return !!current && current.readyState === WebSocket.OPEN;
};

/**
 * Ensures a live connection exists, reconnecting transparently if needed.
 */
export const ensureConnection = async (): Promise<WebSocket> => {
  return isAlive() ? (get(ws) as WebSocket) : connect();
};
