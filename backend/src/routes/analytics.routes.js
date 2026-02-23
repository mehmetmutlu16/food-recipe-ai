import { Router } from 'express';
import { getAnalyticsSummary } from '../repositories/recipe-repository.js';
import { asyncHandler } from '../utils/http.js';

const router = Router();

router.get(
  '/analytics/summary',
  asyncHandler(async (req, res) => {
    const daysRaw = Number(req.query?.days);
    const days = Number.isFinite(daysRaw) && daysRaw > 0 ? Math.round(daysRaw) : 7;
    const summary = await getAnalyticsSummary({ days });
    res.json(summary);
  })
);

export { router as analyticsRoutes };
