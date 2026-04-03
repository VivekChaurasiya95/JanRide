import { HttpError } from '../utils/httpError.js';
import { getUserFromTokenPayload, verifyAccessToken } from '../services/authService.js';

export function authenticate(req, _res, next) {
  const authHeader = req.headers.authorization ?? '';
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null;
  if (!token) {
    next(new HttpError(401, 'Missing access token'));
    return;
  }

  try {
    const payload = verifyAccessToken(token);
    req.user = getUserFromTokenPayload(payload);
    next();
  } catch (_error) {
    next(new HttpError(401, 'Invalid access token'));
  }
}

