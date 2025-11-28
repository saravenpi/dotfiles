import type { Hono } from 'hono';
import { readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';

export async function loadRoutes(webserver: Hono) {
  const routesDir = 'src/routes';
  for (const entry of readdirSync(routesDir)) {
    const moduleDir = join(routesDir, entry);
    if (!statSync(moduleDir).isDirectory()) continue;

    const routeFile = join(moduleDir, `route.ts`);
    try {
      const { default: routeHandler } = await import(
        pathToFileURL(routeFile).href
      );

      webserver.route(`/${entry}`, routeHandler);
      console.log(`[routes] ⇢   ${routeFile}  ->  /${entry}`);
    } catch (err: any) {
      if (err.code === 'ERR_MODULE_NOT_FOUND' || err.code === 'MODULE_NOT_FOUND') {
        console.warn(`[routes] (skip) Aucun fichier route pour "${entry}"`);
        console.warn("tried to access but error: ", err.message);
        continue;
      }
      throw err;
    }
  }
}

export default loadRoutes;
