export class Response {
  ok(data: any = null, message: string = 'Success') {
    return {
      status: 'ok',
      message,
      data,
    };
  }

  error(message: string, code: number = 500) {
    return {
      status: 'error',
      message,
      code,
    };
  }

  notFound(message: string = 'Resource not found') {
    return this.error(message, 404);
  }

  unauthorized(message: string = 'Unauthorized access') {
    return this.error(message, 401);
  }

  created(data: any = null, message: string = 'Resource created successfully') {
    return {
      status: 'created',
      data,
      message,
    }
  }
}

export default new Response();
