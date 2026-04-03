import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';

import { env } from './config/env.js';
import { errorHandler } from './middleware/errorHandler.js';
import { v1Router } from './routes/v1.js';

const app = express();

app.use(helmet());
app.use(cors({ origin: env.allowedOrigin === '*' ? true : env.allowedOrigin }));
app.use(express.json({ limit: '1mb' }));
app.use(morgan('dev'));

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'janride-backend' });
});

app.use('/v1', v1Router);

app.use(errorHandler);

app.listen(env.port, () => {
  // eslint-disable-next-line no-console
  console.log(`JanRide backend listening at http://localhost:${env.port}`);
});

