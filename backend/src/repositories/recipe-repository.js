import { FieldValue, firestore } from '../config/firebase.js';
import { getNormalizedRequestIngredients } from '../utils/ingredients.js';

const COLLECTIONS = {
  requests: 'recipe_requests',
  recipes: 'recipes'
};

export async function logRecipeRequest({
  inputType,
  rawIngredientsText = null,
  recognizedIngredients = [],
  status,
  errorCode = null
}) {
  const normalizedIngredients = getNormalizedRequestIngredients({
    recognizedIngredients,
    rawIngredientsText
  });

  const doc = await firestore.collection(COLLECTIONS.requests).add({
    createdAt: FieldValue.serverTimestamp(),
    inputType,
    rawIngredientsText,
    recognizedIngredients: normalizedIngredients,
    status,
    errorCode
  });

  return doc.id;
}

export async function updateRecipeRequest({
  requestId,
  inputType,
  rawIngredientsText = null,
  recognizedIngredients = [],
  status,
  errorCode = null
}) {
  if (!requestId) {
    throw new Error('requestId is required');
  }

  const normalizedIngredients = getNormalizedRequestIngredients({
    recognizedIngredients,
    rawIngredientsText
  });

  await firestore
    .collection(COLLECTIONS.requests)
    .doc(requestId)
    .set(
      {
        inputType,
        rawIngredientsText,
        recognizedIngredients: normalizedIngredients,
        status,
        errorCode
      },
      { merge: true }
    );
}

export async function logRecipeResult({ requestId, recipe }) {
  await firestore.collection(COLLECTIONS.recipes).add({
    requestId,
    name: recipe.name,
    ingredients: recipe.ingredients,
    steps: recipe.steps,
    prepTimeMinutes: recipe.prepTimeMinutes,
    difficulty: recipe.difficulty,
    source: recipe.source ?? 'mobile',
    createdAt: FieldValue.serverTimestamp()
  });
}

export async function getAnalyticsSummary({ days = 7 } = {}) {
  const now = new Date();
  const from = new Date(now);
  from.setDate(now.getDate() - Math.max(days, 1));

  const requestSnap = await firestore
    .collection(COLLECTIONS.requests)
    .where('createdAt', '>=', from)
    .get();

  const generationCountByDay = {};
  const ingredientCount = {};
  let successCount = 0;
  let failedCount = 0;

  requestSnap.forEach((doc) => {
    const data = doc.data();
    const createdAt = data.createdAt?.toDate?.() ?? now;
    const day = createdAt.toISOString().slice(0, 10);
    generationCountByDay[day] = (generationCountByDay[day] ?? 0) + 1;

    if (data.status === 'success') {
      successCount += 1;
    } else if (data.status === 'failed') {
      failedCount += 1;
    }

    const items = getNormalizedRequestIngredients({
      recognizedIngredients: data.recognizedIngredients,
      rawIngredientsText: data.rawIngredientsText
    });
    for (const item of items) {
      const key = String(item ?? '').trim().toLowerCase();
      if (!key) {
        continue;
      }
      ingredientCount[key] = (ingredientCount[key] ?? 0) + 1;
    }
  });

  const topIngredients = Object.entries(ingredientCount)
    .map(([name, count]) => ({ name, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, 10);

  const generationCount = Object.entries(generationCountByDay)
    .map(([date, count]) => ({ date, count }))
    .sort((a, b) => a.date.localeCompare(b.date));

  return {
    totals: {
      all: requestSnap.size,
      success: successCount,
      failed: failedCount
    },
    generationCount,
    topIngredients
  };
}

export async function getRecipeRequestHistory({
  limit = 20,
  status = null,
  inputType = null,
  includeRecipe = true
} = {}) {
  const normalizedLimit = Math.max(1, Math.min(Number(limit) || 20, 100));
  const queryLimit = status || inputType ? Math.min(normalizedLimit * 5, 300) : normalizedLimit;

  const snapshot = await firestore
    .collection(COLLECTIONS.requests)
    .orderBy('createdAt', 'desc')
    .limit(queryLimit)
    .get();

  const items = snapshot.docs
    .map((doc) => {
      const data = doc.data();
      return {
        id: doc.id,
        createdAt: data.createdAt?.toDate?.()?.toISOString?.() ?? null,
        inputType: data.inputType ?? null,
        rawIngredientsText: data.rawIngredientsText ?? null,
        recognizedIngredients: getNormalizedRequestIngredients({
          recognizedIngredients: data.recognizedIngredients,
          rawIngredientsText: data.rawIngredientsText
        }),
        status: data.status ?? null,
        errorCode: data.errorCode ?? null
      };
    })
    .filter((item) => (status ? item.status === status : true))
    .filter((item) => (inputType ? item.inputType === inputType : true))
    .slice(0, normalizedLimit);

  if (!includeRecipe || items.length === 0) {
    return items;
  }

  const withRecipe = await Promise.all(
    items.map(async (item) => {
      const recipeSnap = await firestore
        .collection(COLLECTIONS.recipes)
        .where('requestId', '==', item.id)
        .limit(1)
        .get();

      if (recipeSnap.empty) {
        return { ...item, recipe: null };
      }

      const recipeData = recipeSnap.docs[0].data();
      return {
        ...item,
        recipe: {
          id: recipeSnap.docs[0].id,
          name: recipeData.name ?? null,
          ingredients: Array.isArray(recipeData.ingredients) ? recipeData.ingredients : [],
          steps: Array.isArray(recipeData.steps) ? recipeData.steps : [],
          prepTimeMinutes: recipeData.prepTimeMinutes ?? null,
          difficulty: recipeData.difficulty ?? null,
          source: recipeData.source ?? null
        }
      };
    })
  );

  return withRecipe;
}
