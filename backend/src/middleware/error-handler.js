export function errorHandler(err, req, res, next) {
  const statusCode =
    Number(err?.statusCode ?? err?.status ?? (err?.type === 'entity.too.large' ? 413 : 0)) ||
    500;

  const message = resolveMessage(err, statusCode);

  res.status(statusCode).json({
    error: {
      message,
      code: statusCode >= 500 ? 'INTERNAL_ERROR' : 'BAD_REQUEST'
    }
  });
}

function resolveMessage(err, statusCode) {
  if (statusCode === 413 || err?.type === 'entity.too.large') {
    return 'Gonderilen gorsel cok buyuk. Lutfen daha kucuk bir dosya deneyin.';
  }

  if (statusCode >= 500) {
    return 'Internal server error';
  }

  if (typeof err?.message === 'string' && err.message.trim().length > 0) {
    return err.message;
  }

  return 'Bad request';
}
