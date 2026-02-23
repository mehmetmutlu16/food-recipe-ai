# AI Recipe Assistant Backend

Node.js + Express API for mobile and dashboard.

## Endpoints

- `GET /api/health`
- `POST /api/ingredients/recognize`
- `POST /api/recipes/generate`
- `GET /api/requests/history?limit=20&status=success&inputType=image`
- `GET /api/analytics/summary?days=7`

## Prompt Strategy

- Prompts are written in English for stronger model control.
- Recipe content output is forced to Turkish.
- JSON output is constrained with `responseMimeType: application/json` and `responseSchema`.
- Prompt files:
  - `src/services/prompt-factory.js`
  - `src/services/gemini-service.js`

## Setup

1. Copy env template:
   - `.env.example` -> `.env`
2. Fill Gemini and Firebase Admin credentials.
3. Install and run:
   - `npm install`
   - `npm run dev`

Default port: `3001`
