import admin from 'firebase-admin';
import { env } from './env.js';

// Required service-account fields for Firebase Admin initialization.
const requiredEnvVars = [
  ['FIREBASE_PROJECT_ID', env.firebaseProjectId],
  ['FIREBASE_CLIENT_EMAIL', env.firebaseClientEmail],
  ['FIREBASE_PRIVATE_KEY', env.firebasePrivateKey],
];

export function getFirebaseAdmin() {
  const missingEnvVars = requiredEnvVars
    .filter(([, value]) => !value || !value.trim())
    .map(([name]) => name);

  if (missingEnvVars.length > 0) {
    throw new Error(
      `Missing Firebase Admin environment variables: ${missingEnvVars.join(', ')}`,
    );
  }

  const projectId = env.firebaseProjectId;
  const clientEmail = env.firebaseClientEmail;
  const privateKey = env.firebasePrivateKey;

  try {
    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          clientEmail,
          privateKey,
        }),
      });
    }
  } catch (error) {
    throw new Error(`Failed to initialize Firebase Admin SDK: ${error.message}`);
  }

  return admin;
}

export default getFirebaseAdmin;

