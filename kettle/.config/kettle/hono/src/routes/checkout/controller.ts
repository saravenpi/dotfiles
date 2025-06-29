import type { Context } from "hono";
import Response from "@/response";

export class CheckoutController {
  async index(c: Context) {
    try {
      return c.json(Response.ok())
    } catch (error: Error | any) {
      return c.json(Response.error(error))
    }
  }
}

export default new CheckoutController();
