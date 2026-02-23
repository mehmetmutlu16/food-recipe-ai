import dotenv from 'dotenv';

dotenv.config();

function required(name) {
  const value = process.env[name];
  if (!value || value.trim().length === 0) {
    throw new Error(`Missing required env var: ${name}`);
  }
  return value;
}

function optional(name, fallback) {
  const value = process.env[name];
  if (!value || value.trim().length === 0) {
    return fallback;
  }
  return value;
}

export const env = {
  nodeEnv: optional('NODE_ENV', 'development'),
  port: Number(optional('PORT', '3001')),
  corsOrigin: optional('CORS_ORIGIN', '*'),

  geminiApiKey: required('GEMINI_API_KEY'),
  geminiRecipeModel: optional('GEMINI_RECIPE_MODEL', 'gemini-2.5-flash'),
  geminiVisionModel: optional('GEMINI_VISION_MODEL', 'gemini-2.5-flash'),

  firebaseProjectId: required('FIREBASE_PROJECT_ID'),
  firebaseClientEmail: required('FIREBASE_CLIENT_EMAIL'),
  firebasePrivateKey: required('FIREBASE_PRIVATE_KEY').replace(/\\n/g, '\n')
};
