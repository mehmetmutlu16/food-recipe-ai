import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';
import { env } from './config/env.js';
import { analyticsRoutes } from './routes/analytics.routes.js';
import { healthRoutes } from './routes/health.routes.js';
import { ingredientRoutes } from './routes/ingredients.routes.js';
import { requestRoutes } from './routes/requests.routes.js';
import { recipeRoutes } from './routes/recipes.routes.js';
import { errorHandler } from './middleware/error-handler.js';

export const app = express();

app.use(helmet());
app.use(cors({ origin: env.corsOrigin === '*' ? true : env.corsOrigin }));
app.use(morgan(env.nodeEnv === 'development' ? 'dev' : 'combined'));
app.use(express.json({ limit: '20mb' }));

app.use('/api', healthRoutes);
app.use('/api', ingredientRoutes);
app.use('/api', recipeRoutes);
app.use('/api', requestRoutes);
app.use('/api', analyticsRoutes);

app.use((req, res) => {
  res.status(404).json({
    error: {
      message: 'Route not found',
      code: 'NOT_FOUND'
    }
  });
});

app.use(errorHandler);
