export function asyncHandler(fn) {
  return async (req, res, next) => {
    try {
      await fn(req, res, next);
    } catch (error) {
      next(error);
    }
  };
}

export function badRequest(message) {
  const error = new Error(message);
  error.statusCode = 400;
  return error;
}
