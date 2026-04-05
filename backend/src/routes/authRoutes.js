import { Router } from 'express';

import { postVerifyFirebaseToken } from '../controllers/authController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

export const authRouter = Router();

// Public endpoint used by Flutter after Firebase OTP/Google sign-in.
authRouter.post('/verify', postVerifyFirebaseToken);

// Protected endpoint to validate bearer token wiring.
authRouter.get('/me', authMiddleware, (req, res) => {
  res.json({
    uid: req.user.uid,
    phoneNumber: req.user.phone_number ?? null,
    email: req.user.email ?? null,
  });
});
