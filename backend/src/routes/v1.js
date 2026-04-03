import { Router } from 'express';

import {
  getMe,
  postSendOtp,
  postVerifyGoogle,
  postVerifyOtp,
  putMyPreferences,
  putMyProfile,
} from '../controllers/authController.js';
import {
  fetchCrowdReports,
  fetchHeatmap,
  fetchPeakHours,
  fetchRoutes,
  fetchStops,
  postCrowdReport,
  postRouteSearch,
} from '../controllers/transportController.js';
import { authenticate } from '../middleware/authenticate.js';

export const v1Router = Router();

v1Router.post('/auth/otp/send', postSendOtp);
v1Router.post('/auth/otp/verify', postVerifyOtp);
v1Router.post('/auth/verify', postVerifyGoogle);

v1Router.get('/stops', fetchStops);
v1Router.get('/routes', fetchRoutes);
v1Router.post('/route-search', postRouteSearch);

v1Router.get('/analytics/heatmap', fetchHeatmap);
v1Router.get('/analytics/peak-hours', fetchPeakHours);

v1Router.get('/crowd-reports', fetchCrowdReports);
v1Router.post('/crowd-report', authenticate, postCrowdReport);

v1Router.get('/me', authenticate, getMe);
v1Router.put('/me/profile', authenticate, putMyProfile);
v1Router.put('/me/preferences', authenticate, putMyPreferences);

