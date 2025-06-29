import { Hono } from 'hono'
import CheckoutController from './controller';

const router = new Hono();

router.get('/', CheckoutController.index);

export default router;

