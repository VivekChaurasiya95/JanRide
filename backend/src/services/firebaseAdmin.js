import getFirebaseAdmin from '../config/firebase.js';
import { HttpError } from '../utils/httpError.js';

export async function verifyFirebaseIdToken(idToken) {
  try {
    const firebaseAdmin = getFirebaseAdmin();
    return await firebaseAdmin.auth().verifyIdToken(idToken, true);
  } catch (error) {
    if (error?.message?.includes('Missing Firebase Admin environment variables')) {
      throw new HttpError(
        501,
        'Firebase Admin is not configured. Set FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, and FIREBASE_PRIVATE_KEY.',
      );
    }
    throw new HttpError(401, 'Invalid or expired Firebase token');
  }
}

