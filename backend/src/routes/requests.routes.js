import { Router } from 'express';
import { getRecipeRequestHistory } from '../repositories/recipe-repository.js';
import { asyncHandler } from '../utils/http.js';

const router = Router();

router.get(
  '/requests/history',
  asyncHandler(async (req, res) => {
    const limitRaw = Number(req.query?.limit);
    const limit = Number.isFinite(limitRaw) && limitRaw > 0 ? Math.round(limitRaw) : 20;

    const statusRaw = String(req.query?.status ?? '').trim();
    const status = statusRaw === 'success' || statusRaw === 'failed' ? statusRaw : null;

    const inputTypeRaw = String(req.query?.inputType ?? '').trim();
    const inputType =
      inputTypeRaw === 'text' || inputTypeRaw === 'image' || inputTypeRaw === 'mixed'
        ? inputTypeRaw
        : null;

    const includeRecipeRaw = String(req.query?.includeRecipe ?? 'true')
      .trim()
      .toLowerCase();
    const includeRecipe = includeRecipeRaw !== 'false';

    const requests = await getRecipeRequestHistory({
      limit,
      status,
      inputType,
      includeRecipe
    });

    res.json({
      count: requests.length,
      requests
    });
  })
);

export { router as requestRoutes };
