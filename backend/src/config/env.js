import dotenv from 'dotenv';

dotenv.config();

const env = {
  // Server
  port: Number(process.env.PORT ?? 5000),

  // Security
  jwtSecret: process.env.JWT_SECRET ?? 'change-this-secret',

  // CORS
  allowedOrigin: process.env.ALLOWED_ORIGIN ?? '*',

  // OTP
  otpTtlSeconds: Number(process.env.OTP_TTL_SECONDS ?? 120),
  devOtpCode: process.env.DEV_OTP_CODE ?? '123456',

  // Firebase Admin
  firebaseProjectId: process.env.FIREBASE_PROJECT_ID ?? '',
  firebaseClientEmail: process.env.FIREBASE_CLIENT_EMAIL ?? '',
  firebasePrivateKey: (process.env.FIREBASE_PRIVATE_KEY ?? '').replace(/\\n/g, '\n'),
};

export { env };
