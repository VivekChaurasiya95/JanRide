import dotenv from 'dotenv';

dotenv.config();

export const env = {
  port: Number(process.env.PORT ?? 8080),
  jwtSecret: process.env.JWT_SECRET ?? 'change-this-secret',
  allowedOrigin: process.env.ALLOWED_ORIGIN ?? '*',
  otpTtlSeconds: Number(process.env.OTP_TTL_SECONDS ?? 120),
  devOtpCode: process.env.DEV_OTP_CODE ?? '123456',
};

