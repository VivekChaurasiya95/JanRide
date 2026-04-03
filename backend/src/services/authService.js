import jwt from 'jsonwebtoken';
import { v4 as uuid } from 'uuid';

import { env } from '../config/env.js';
import { HttpError } from '../utils/httpError.js';

const otpStore = new Map();
const userStore = new Map();

export function sendOtp(phoneE164) {
  const verificationId = uuid();
  otpStore.set(verificationId, {
    phoneE164,
    otpCode: env.devOtpCode,
    expiresAt: Date.now() + env.otpTtlSeconds * 1000,
  });

  return {
    verificationId,
    ttlSeconds: env.otpTtlSeconds,
    // This field is for development only and should be removed in production.
    debugOtpCode: env.devOtpCode,
  };
}

export function verifyOtp({ phoneE164, verificationId, otpCode }) {
  const entry = otpStore.get(verificationId);
  if (!entry || entry.phoneE164 !== phoneE164) {
    throw new HttpError(400, 'Invalid verification session. Please request OTP again.');
  }
  if (Date.now() > entry.expiresAt) {
    otpStore.delete(verificationId);
    throw new HttpError(400, 'OTP expired. Please request a new OTP.');
  }
  if (entry.otpCode !== otpCode) {
    throw new HttpError(401, 'Wrong OTP');
  }

  otpStore.delete(verificationId);
  const user = getOrCreateUser({ phone: phoneE164 });
  const accessToken = issueAccessToken(user.id);

  return {
    accessToken,
    user,
    profileCompleted: user.profileCompleted,
  };
}

export function verifyGoogleToken(token) {
  if (!token || token.length < 8) {
    throw new HttpError(401, 'Invalid Google token');
  }

  // Dev-safe behavior: allow local integration before Firebase Admin is configured.
  if (!token.startsWith('dev-')) {
    throw new HttpError(
      501,
      'Firebase Google token verification not configured yet. Set up Firebase Admin and replace dev token flow.',
    );
  }

  const user = getOrCreateUser({ phone: '+910000000000', email: 'dev.user@janride.app', name: 'JanRide Dev User' });
  const accessToken = issueAccessToken(user.id);
  return {
    accessToken,
    user,
    profileCompleted: user.profileCompleted,
  };
}

export function getUserFromTokenPayload(payload) {
  const user = userStore.get(payload.sub);
  if (!user) {
    throw new HttpError(401, 'User not found');
  }
  return user;
}

export function upsertProfile(userId, { name, language, photoUrl }) {
  const user = userStore.get(userId);
  if (!user) {
    throw new HttpError(404, 'User not found');
  }

  user.name = name;
  user.language = language ?? user.language ?? 'English';
  user.photoUrl = photoUrl ?? user.photoUrl;
  user.profileCompleted = true;
  return user;
}

export function upsertPreferences(
  userId,
  {
    locationEnabled,
    notificationsEnabled,
    locationPermissionGranted,
    notificationPermissionGranted,
  },
) {
  const user = userStore.get(userId);
  if (!user) {
    throw new HttpError(404, 'User not found');
  }

  user.preferences = {
    ...user.preferences,
    locationEnabled,
    notificationsEnabled,
    locationPermissionGranted,
    notificationPermissionGranted,
    updatedAt: new Date().toISOString(),
  };

  return user;
}

export function verifyAccessToken(rawToken) {
  return jwt.verify(rawToken, env.jwtSecret);
}

function issueAccessToken(userId) {
  return jwt.sign({ sub: userId, scope: 'rider' }, env.jwtSecret, { expiresIn: '7d' });
}

function getOrCreateUser({ phone, email, name }) {
  const existing = [...userStore.values()].find((u) => u.phone === phone || (email && u.email === email));
  if (existing) {
    return existing;
  }

  const user = {
    id: uuid(),
    name: name ?? 'JanRide User',
    phone,
    email: email ?? null,
    photoUrl: null,
    trustScore: 0.5,
    profileCompleted: false,
    reportsCount: 0,
    preferences: {
      locationEnabled: false,
      notificationsEnabled: false,
      locationPermissionGranted: false,
      notificationPermissionGranted: false,
      updatedAt: new Date().toISOString(),
    },
    createdAt: new Date().toISOString(),
  };
  userStore.set(user.id, user);
  return user;
}

