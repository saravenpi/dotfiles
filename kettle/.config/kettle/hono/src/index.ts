import router from "./router";

import { serve } from "bun";

console.log("[webserver] Starting server on port 8080...");

serve({
  fetch: router.fetch,
  port: 8080,
});
