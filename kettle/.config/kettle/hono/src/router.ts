import { Hono } from 'hono';
import { logger } from 'hono/logger';
import { cors } from 'hono/cors';
import loadRoutes from '@/loadRoutes';


export const router = new Hono();

router.use(logger());
router.use('/*', cors())

await loadRoutes(router);

export default router;
