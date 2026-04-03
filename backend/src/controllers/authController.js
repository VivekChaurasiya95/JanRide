import { z } from 'zod';

import {
  sendOtp,
  upsertPreferences,
  upsertProfile,
  verifyGoogleToken,
  verifyOtp,
} from '../services/authService.js';

const sendOtpSchema = z.object({
  phoneE164: z.string().regex(/^\+\d{10,15}$/),
});

const verifyOtpSchema = z.object({
  phoneE164: z.string().regex(/^\+\d{10,15}$/),
  verificationId: z.string().min(8),
  otpCode: z.string().regex(/^\d{4,6}$/),
});

const verifyGoogleSchema = z.object({
  token: z.string().min(8),
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

export function postVerifyGoogle(req, res) {
  const payload = verifyGoogleSchema.parse(req.body);
  res.json(verifyGoogleToken(payload.token));
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

