import { Router } from 'express';
import { recognizeIngredientsFromImage } from '../services/gemini-service.js';
import { logRecipeRequest } from '../repositories/recipe-repository.js';
import { asyncHandler, badRequest } from '../utils/http.js';

const router = Router();

router.post(
  '/ingredients/recognize',
  asyncHandler(async (req, res) => {
    const maxImageBytes = 5 * 1024 * 1024;
    const imageBase64 = String(req.body?.image ?? req.body?.imageBase64 ?? '').trim();
    const mimeType = String(req.body?.mimeType ?? 'image/jpeg').trim() || 'image/jpeg';
    const rawIngredientsText =
      typeof req.body?.rawIngredientsText === 'string'
        ? req.body.rawIngredientsText.trim()
        : null;

    if (!imageBase64) {
      throw badRequest('image is required');
    }

    const estimatedBytes = Math.floor((imageBase64.length * 3) / 4);
    if (estimatedBytes > maxImageBytes) {
      throw badRequest('Image is too large. Please choose a smaller image.');
    }

    try {
      const result = await recognizeIngredientsFromImage({ imageBase64, mimeType });
      try {
        const requestId = await logRecipeRequest({
          inputType: 'image',
          rawIngredientsText,
          recognizedIngredients: result.recognizedIngredients,
          status: 'success'
        });
        res.json({
          ...result,
          requestId
        });
        return;
      } catch (logError) {
        // eslint-disable-next-line no-console
        console.warn('[firestore] recognize success log failed:', logError.message);
      }
      res.json(result);
    } catch (error) {
      try {
        await logRecipeRequest({
          inputType: 'image',
          rawIngredientsText,
          recognizedIngredients: [],
          status: 'failed',
          errorCode: 'RECOGNITION_FAILED'
        });
      } catch (logError) {
        // eslint-disable-next-line no-console
        console.warn('[firestore] recognize failure log failed:', logError.message);
      }
      throw error;
    }
  })
);

export { router as ingredientRoutes };
