import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';

import { env } from './config/env.js';
import { errorHandler } from './middleware/errorHandler.js';
import { authRouter } from './routes/authRoutes.js';
import { v1Router } from './routes/v1.js';

const PORT = process.env.PORT || env.port || 5000;
const app = express();

app.use(helmet());
app.use(cors({ origin: env.allowedOrigin === '*' ? true : env.allowedOrigin }));
app.use(express.json({ limit: '1mb' }));
app.use(morgan('dev'));

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'janride-backend' });
});

app.get('/', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'janride-backend',
    hint: 'Use /v1/* endpoints for API calls.',
  });
});

app.get('/favicon.ico', (_req, res) => {
  res.status(204).end();
});

app.use('/api/auth', authRouter);
app.use('/v1', v1Router);

app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`🚀 JanRide backend running at http://localhost:${PORT}`);
});

