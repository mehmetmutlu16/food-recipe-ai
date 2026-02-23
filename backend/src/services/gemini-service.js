import { env } from '../config/env.js';
import {
  buildRecognitionPrompt,
  buildRecipePrompt,
  recognitionSystemInstruction,
  recipeSystemInstruction
} from './prompt-factory.js';
import { extractJsonObject } from '../utils/json.js';

const GEMINI_BASE_URL = 'https://generativelanguage.googleapis.com/v1beta';

const recognitionSchema = {
  type: 'OBJECT',
  properties: {
    recognizedIngredients: {
      type: 'ARRAY',
      items: { type: 'STRING' }
    }
  },
  required: ['recognizedIngredients']
};

const recipeSchema = {
  type: 'OBJECT',
  properties: {
    name: { type: 'STRING' },
    ingredients: {
      type: 'ARRAY',
      items: {
        type: 'OBJECT',
        properties: {
          name: { type: 'STRING' },
          quantity: { type: 'NUMBER' },
          unit: { type: 'STRING' }
        },
        required: ['name', 'quantity', 'unit']
      }
    },
    steps: {
      type: 'ARRAY',
      items: { type: 'STRING' }
    },
    prepTimeMinutes: { type: 'INTEGER' },
    difficulty: {
      type: 'STRING',
      enum: ['easy', 'medium', 'hard']
    }
  },
  required: ['name', 'ingredients', 'steps', 'prepTimeMinutes', 'difficulty']
};

export async function recognizeIngredientsFromImage({ imageBase64, mimeType }) {
  const payload = await generateJson({
    model: env.geminiVisionModel,
    systemInstruction: recognitionSystemInstruction,
    parts: [
      { text: buildRecognitionPrompt() },
      {
        inline_data: {
          mime_type: mimeType || 'image/jpeg',
          data: imageBase64
        }
      }
    ],
    schema: recognitionSchema
  });

  const raw = payload.recognizedIngredients;
  const result = Array.isArray(raw)
    ? raw
        .map((value) => String(value).trim())
        .filter((value) => value.length > 0)
    : [];

  return { recognizedIngredients: [...new Set(result)] };
}

export async function generateRecipeFromIngredients({ ingredients, notes }) {
  const payload = await generateJson({
    model: env.geminiRecipeModel,
    systemInstruction: recipeSystemInstruction,
    parts: [
      {
        text: buildRecipePrompt({ ingredients, notes })
      }
    ],
    schema: recipeSchema
  });

  return normalizeRecipe(payload);
}

async function generateJson({ model, systemInstruction, parts, schema }) {
  let lastError;
  for (let attempt = 0; attempt < 2; attempt += 1) {
    try {
      const response = await fetch(
        `${GEMINI_BASE_URL}/models/${model}:generateContent?key=${encodeURIComponent(env.geminiApiKey)}`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            system_instruction: {
              parts: [{ text: systemInstruction }]
            },
            contents: [
              {
                role: 'user',
                parts
              }
            ],
            generationConfig: {
              temperature: 1.0,
              topP: 0.95,
              responseMimeType: 'application/json',
              responseSchema: schema
            }
          })
        }
      );

      const data = await response.json();
      if (!response.ok) {
        const message =
          data?.error?.message || `Gemini request failed with status ${response.status}`;
        throw new Error(message);
      }

      const text = extractCandidateText(data);
      return extractJsonObject(text);
    } catch (error) {
      lastError = error;
    }
  }

  throw lastError ?? new Error('Gemini request failed.');
}

function extractCandidateText(data) {
  const blockReason = data?.promptFeedback?.blockReason;
  if (blockReason) {
    throw new Error(`Gemini blocked request: ${blockReason}`);
  }

  const candidates = data?.candidates;
  if (!Array.isArray(candidates) || candidates.length === 0) {
    throw new Error('Gemini returned no candidates.');
  }

  const parts = candidates[0]?.content?.parts;
  if (!Array.isArray(parts) || parts.length === 0) {
    throw new Error('Gemini candidate parts are empty.');
  }

  const text = parts
    .map((part) => (typeof part?.text === 'string' ? part.text : ''))
    .join('')
    .trim();

  if (!text) {
    throw new Error('Gemini returned empty content.');
  }

  return text;
}

function normalizeRecipe(input) {
  const ingredients = Array.isArray(input.ingredients)
    ? input.ingredients
        .map((item) => {
          if (!item || typeof item !== 'object') {
            return null;
          }
          const name = String(item.name ?? '').trim();
          if (!name) {
            return null;
          }
          const quantityRaw = Number(item.quantity);
          const quantity = Number.isFinite(quantityRaw) && quantityRaw > 0 ? quantityRaw : 1;
          const unit = String(item.unit ?? 'adet').trim() || 'adet';
          return { name, quantity, unit };
        })
        .filter(Boolean)
    : [];

  const steps = Array.isArray(input.steps)
    ? input.steps
        .map((step) => String(step ?? '').trim())
        .filter((step) => step.length > 0)
    : [];

  const difficulty = normalizeDifficulty(input.difficulty);
  const prepTimeRaw = Number(input.prepTimeMinutes);
  const prepTimeMinutes =
    Number.isFinite(prepTimeRaw) && prepTimeRaw > 0 ? Math.round(prepTimeRaw) : 30;

  return {
    name: String(input.name ?? 'Yapay Zeka Tarifi').trim() || 'Yapay Zeka Tarifi',
    ingredients,
    steps: steps.length > 0 ? steps : ['Malzemeleri karistirip pisirin.'],
    prepTimeMinutes,
    difficulty
  };
}

function normalizeDifficulty(value) {
  const key = String(value ?? '').trim().toLowerCase();
  if (key === 'easy' || key === 'medium' || key === 'hard') {
    return key;
  }
  return 'medium';
}
