import { z } from 'zod';

import {
  sendOtp,
  upsertPreferences,
  upsertProfile,
  verifyFirebaseToken,
  verifyOtp,
} from '../services/authService.js';
import { HttpError } from '../utils/httpError.js';

const sendOtpSchema = z.object({
  phoneE164: z.string().regex(/^\+\d{10,15}$/),
});

const verifyOtpSchema = z.object({
  phoneE164: z.string().regex(/^\+\d{10,15}$/),
  verificationId: z.string().min(8),
  otpCode: z.string().regex(/^\d{4,6}$/),
});

const verifyGoogleSchema = z.object({
  token: z.string().min(8).optional(),
});

const profileSchema = z.object({
  name: z.string().min(2),
  language: z.string().min(2).optional(),
  photoUrl: z.string().url().optional(),
});

const preferencesSchema = z.object({
  locationEnabled: z.boolean(),
  notificationsEnabled: z.boolean(),
  locationPermissionGranted: z.boolean().optional(),
  notificationPermissionGranted: z.boolean().optional(),
});

export function postSendOtp(req, res) {
  const payload = sendOtpSchema.parse(req.body);
  res.json(sendOtp(payload.phoneE164));
}

export function postVerifyOtp(req, res) {
  const payload = verifyOtpSchema.parse(req.body);
  res.json(verifyOtp(payload));
}

export async function postVerifyGoogle(req, res) {
  const payload = verifyGoogleSchema.parse(req.body ?? {});
  const token = _extractBearerOrBodyToken(req, payload.token);
  res.json(await verifyFirebaseToken(token));
}

export async function postVerifyFirebaseToken(req, res) {
  const payload = verifyGoogleSchema.parse(req.body ?? {});
  const token = _extractBearerOrBodyToken(req, payload.token);
  const result = await verifyFirebaseToken(token);
  res.json({
    uid: result.user.id,
    phoneNumber: result.user.phone || null,
    email: result.user.email || null,
    isNewUser: !result.profileCompleted,
    accessToken: result.accessToken,
    user: result.user,
    profileCompleted: result.profileCompleted,
  });
}

function _extractBearerOrBodyToken(req, bodyToken) {
  const authHeader = req.headers.authorization ?? '';
  const bearerToken = authHeader.startsWith('Bearer ')
    ? authHeader.slice(7).trim()
    : '';

  const token = bearerToken || (bodyToken ?? '').trim();
  if (!token) {
    throw new HttpError(400, 'Missing Firebase token. Send Authorization: Bearer <token> or token in body.');
  }
  return token;
}

export function getMe(req, res) {
  res.json({ user: req.user });
}

export function putMyProfile(req, res) {
  const payload = profileSchema.parse(req.body);
  const updated = upsertProfile(req.user.id, payload);
  res.json({ user: updated, profileCompleted: updated.profileCompleted });
}

export function putMyPreferences(req, res) {
  const payload = preferencesSchema.parse(req.body);
  const updated = upsertPreferences(req.user.id, {
    ...payload,
    locationPermissionGranted:
      payload.locationPermissionGranted ??
      req.user.preferences?.locationPermissionGranted ??
      false,
    notificationPermissionGranted:
      payload.notificationPermissionGranted ??
      req.user.preferences?.notificationPermissionGranted ??
      false,
  });
  res.json({ user: updated, preferences: updated.preferences });
}

