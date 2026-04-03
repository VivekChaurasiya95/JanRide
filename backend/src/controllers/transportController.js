import { z } from 'zod';

import { searchRoute, getRoutes, getStops } from '../services/routeService.js';
import { addCrowdReport, getCrowdReports } from '../services/crowdService.js';
import { getHeatmap, getPeakHours } from '../services/analyticsService.js';

const routeSearchSchema = z.object({
  from: z.string().min(2),
  to: z.string().min(2),
  preference: z.string().optional(),
});

const crowdSchema = z.object({
  stop_id: z.string().min(2),
  type: z.enum(['light', 'moderate', 'heavy']),
});

export function fetchStops(_req, res) {
  res.json({ stops: getStops() });
}

export function fetchRoutes(_req, res) {
  res.json({ routes: getRoutes() });
}

export function postRouteSearch(req, res) {
  const payload = routeSearchSchema.parse(req.body);
  res.json({ routes: searchRoute(payload) });
}

export function postCrowdReport(req, res) {
  const payload = crowdSchema.parse(req.body);
  const report = addCrowdReport({ ...payload, user_id: req.user.id });
  res.status(201).json({ report });
}

export function fetchCrowdReports(_req, res) {
  res.json({ reports: getCrowdReports() });
}

export function fetchHeatmap(_req, res) {
  res.json({ heatmap: getHeatmap() });
}

export function fetchPeakHours(_req, res) {
  res.json({ peakHours: getPeakHours() });
}

