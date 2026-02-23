import { Router } from 'express';
import { generateRecipeFromIngredients } from '../services/gemini-service.js';
import {
  logRecipeRequest,
  logRecipeResult,
  updateRecipeRequest
} from '../repositories/recipe-repository.js';
import { asyncHandler, badRequest } from '../utils/http.js';

const router = Router();

router.post(
  '/recipes/generate',
  asyncHandler(async (req, res) => {
    const ingredientsInput = req.body?.ingredients;
    const notes =
      typeof req.body?.notes === 'string'
        ? req.body.notes.trim()
        : typeof req.body?.rawText === 'string'
          ? req.body.rawText.trim()
          : null;
    const inputType = String(req.body?.inputType ?? 'text');
    const requestIdRaw = String(req.body?.requestId ?? '').trim();
    const requestId = requestIdRaw || null;

    if (!Array.isArray(ingredientsInput)) {
      throw badRequest('ingredients must be an array');
    }

    const ingredients = ingredientsInput
      .map((item) => String(item ?? '').trim())
      .filter((item) => item.length > 0);

    if (ingredients.length === 0) {
      throw badRequest('ingredients cannot be empty');
    }

    try {
      const recipe = await generateRecipeFromIngredients({
        ingredients,
        notes
      });

      try {
        const normalizedInputType = normalizeInputType(inputType);

        if (requestId) {
          await updateRecipeRequest({
            requestId,
            inputType: normalizedInputType,
            rawIngredientsText: notes,
            recognizedIngredients: ingredients,
            status: 'success',
            errorCode: null
          });
          await logRecipeResult({ requestId, recipe });
        } else {
          const newRequestId = await logRecipeRequest({
            inputType: normalizedInputType,
            rawIngredientsText: notes,
            recognizedIngredients: ingredients,
            status: 'success'
          });
          await logRecipeResult({ requestId: newRequestId, recipe });
        }
      } catch (logError) {
        // eslint-disable-next-line no-console
        console.warn('[firestore] recipe success log failed:', logError.message);
      }

      res.json({ recipe });
    } catch (error) {
      try {
        const normalizedInputType = normalizeInputType(inputType);
        if (requestId) {
          await updateRecipeRequest({
            requestId,
            inputType: normalizedInputType,
            rawIngredientsText: notes,
            recognizedIngredients: ingredients,
            status: 'failed',
            errorCode: 'RECIPE_GENERATION_FAILED'
          });
        } else {
          await logRecipeRequest({
            inputType: normalizedInputType,
            rawIngredientsText: notes,
            recognizedIngredients: ingredients,
            status: 'failed',
            errorCode: 'RECIPE_GENERATION_FAILED'
          });
        }
      } catch (logError) {
        // eslint-disable-next-line no-console
        console.warn('[firestore] recipe failure log failed:', logError.message);
      }
      throw error;
    }
  })
);

function normalizeInputType(value) {
  if (value === 'image' || value === 'mixed' || value === 'text') {
    return value;
  }
  return 'text';
}

export { router as recipeRoutes };
