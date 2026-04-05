import { HttpError } from '../utils/httpError.js';
import { verifyFirebaseIdToken } from '../services/firebaseAdmin.js';

export async function authMiddleware(req, _res, next) {
  try {
    const authHeader = req.headers.authorization ?? '';
    if (!authHeader.startsWith('Bearer ')) {
      throw new HttpError(401, 'Missing Authorization bearer token');
    }

    const token = authHeader.slice(7).trim();
    if (!token) {
      throw new HttpError(401, 'Missing Firebase token');
    }

    const decodedToken = await verifyFirebaseIdToken(token);
    req.user = decodedToken;
    next();
  } catch (error) {
    next(error);
  }
}

