import { z } from 'zod';

import {
  getActivityDashboard,
  getActivityHistory,
  startTrip,
} from '../services/activityService.js';

const startTripSchema = z.object({
  routeId: z.string().min(2),
});

export function fetchActivityDashboard(_req, res) {
  res.json(getActivityDashboard());
}

export function fetchActivityHistory(_req, res) {
  res.json({ history: getActivityHistory() });
}

export function postStartTrip(req, res) {
  const payload = startTripSchema.parse(req.body ?? {});
  const trip = startTrip(payload);
  res.status(201).json({ trip });
}

