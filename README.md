# AI Recipe Assistant (MVP)

Full-stack case study project with:

- `mobile/` Flutter app (BLoC, feature-first)
- `backend/` Node.js + Express API
- `dashboard/` Next.js analytics dashboard
- Firestore as the shared database
- Gemini as the AI provider (vision + recipe generation)

This is intentionally an MVP: no auth, no deployment pipeline, no production hardening.

## 1) What is implemented

### Mobile (Flutter)
- Ingredient input via:
  - text
  - camera/gallery image
- Ingredient recognition flow (image -> backend -> Gemini Vision)
- Recipe generation flow (ingredients -> backend -> Gemini)
- Loading/error/empty states
- Recipe result screen with:
  - recipe name
  - ingredient list with quantities
  - steps
  - prep time
  - difficulty
- Recipe history screen (shows only generated recipes) with detail modal

### Backend (Node.js)
- `GET /api/health`
- `POST /api/ingredients/recognize`
- `POST /api/recipes/generate`
- `GET /api/requests/history`
- `GET /api/analytics/summary`
- Firestore logging for requests and generated recipes
- Prompt-based Gemini integration with JSON-constrained responses
- Centralized error handling

### Dashboard (Next.js)
- Single-page analytics dashboard using backend endpoints
- Metrics/charts:
  - total/success/failed counts
  - generation count by day
  - top ingredients
  - success vs failed ratio
  - hourly trend
  - input type distribution
  - top failure codes
  - recent requests table

## 2) Architecture overview

`Flutter App` -> `Node API` -> `Gemini + Firestore`

- Mobile never calls Gemini directly.
- Backend owns:
  - prompt engineering
  - AI response parsing/normalization
  - Firestore writes/reads
- Dashboard reads analytics through backend API.

## 3) Tech stack

- Mobile: Flutter (Dart), `flutter_bloc`, `dio`, `image_picker`
- Backend: Node.js, Express, Firebase Admin SDK
- Database: Firebase Firestore
- AI: Google Gemini (`gemini-2.5-flash` family)
- Dashboard: Next.js, Recharts, Tailwind CSS

## 4) Firestore data model

### `recipe_requests`
- `createdAt`
- `inputType` (`text` | `image` | `mixed`)
- `rawIngredientsText`
- `recognizedIngredients` (`string[]`)
- `status` (`success` | `failed`)
- `errorCode` (optional)

### `recipes`
- `requestId` (links to `recipe_requests.id`)
- `name`
- `ingredients` (`[{ name, quantity, unit }]`)
- `steps` (`string[]`)
- `prepTimeMinutes`
- `difficulty` (`easy` | `medium` | `hard`)
- `source` (default: `mobile`)
- `createdAt`

## 5) AI strategy and prompt engineering

Prompts are defined in:
- `backend/src/services/prompt-factory.js`

Execution and schema-constrained JSON generation:
- `backend/src/services/gemini-service.js`

Strategy:
- Prompts are in English for control/consistency.
- Recipe content is forced to Turkish.
- Output is constrained to JSON via:
  - `responseMimeType: application/json`
  - `responseSchema`
- Normalization is applied server-side to avoid malformed payloads.
- Retry is applied in Gemini request flow.

## 6) Decision log

1. **Backend-first AI integration**
   - Keeps API keys off mobile
   - Centralizes prompts/parsing/logging
2. **BLoC in Flutter**
   - Predictable event/state flow
   - Easier live debugging and modification
3. **Feature-first + layered mobile structure**
   - `presentation/domain/data` separation
4. **MVP-focused analytics**
   - Useful charts over perfect BI architecture
5. **Pragmatic scope**
   - End-to-end working product prioritized over overengineering

## 7) Local setup

## Prerequisites
- Flutter SDK 3.9+
- Node.js 20+ (22 tested)
- Firebase project + Firestore enabled
- Gemini API key

### A) Backend
```bash
cd backend
cp .env.example .env
# fill values in .env
npm install
npm run dev
```

Backend default:
- `http://localhost:3001`

### B) Mobile
```bash
cd mobile
flutter pub get
flutter run
```

Android emulator default backend URL is already set:
- `http://10.0.2.2:3001/api`

If you run on physical device/custom host:
```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_IP:3001/api
```

Firebase mobile config:
- copy `mobile/android/app/google-services.json.example` to `mobile/android/app/google-services.json`
- fill with your own Firebase project values

### C) Dashboard
```bash
cd dashboard
cp .env.example .env.local
npm install
npm run dev
```

Dashboard:
- `http://localhost:3000`

## 8) Environment variables

### `backend/.env.example`
Includes:
- `GEMINI_API_KEY`
- `GEMINI_RECIPE_MODEL`
- `GEMINI_VISION_MODEL`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_CLIENT_EMAIL`
- `FIREBASE_PRIVATE_KEY`
- `PORT`, `NODE_ENV`, `CORS_ORIGIN`

### `dashboard/.env.example`
- `NEXT_PUBLIC_API_BASE_URL`

Notes:
- Do not commit real keys.
- `FIREBASE_PRIVATE_KEY` must be valid PEM with escaped newlines (`\n`) in `.env`.
- `google-services.json` is ignored; use `google-services.json.example` as template.

## 8.1) Security checklist before GitHub push

1. Ensure real secret files are not staged:
   - `backend/.env`
   - `dashboard/.env.local`
   - `mobile/android/app/google-services.json`
2. Keep only example files in repo:
   - `backend/.env.example`
   - `dashboard/.env.example`
   - `mobile/android/app/google-services.json.example`
3. If any key was exposed, rotate it before submission:
   - Gemini API key
   - Firebase service account private key

## 9) API reference

- `GET /api/health`
- `POST /api/ingredients/recognize`
  - body: `{ image: base64, mimeType?: string }`
- `POST /api/recipes/generate`
  - body: `{ ingredients: string[], inputType?: text|image|mixed, notes?: string }`
- `GET /api/requests/history?limit=60&includeRecipe=true`
- `GET /api/analytics/summary?days=7`

## 10) Testing notes

Manual smoke test path:
1. Text ingredients -> generate recipe
2. Image -> recognize ingredients -> generate recipe
3. Open history -> open recipe detail modal
4. Open dashboard -> verify charts and recent table

Current automated tests are minimal in this MVP.

## 11) Known limitations

- No authentication/authorization
- No rate limiting, no deployment setup
- Limited automated coverage
- Dashboard uses API-level aggregation (no advanced warehouse/precompute jobs)

## 12) Troubleshooting

- **`Connection reset by peer` on image recognize**
  - Restart backend
  - Try smaller image
  - Ensure backend and emulator host mapping (`10.0.2.2`) is correct
- **Firebase private key parse error**
  - Verify `FIREBASE_PRIVATE_KEY` format in `.env`
- **Android emulator cannot reach backend**
  - Confirm backend is running on port `3001`
  - Use `10.0.2.2` (not `localhost`) from emulator

## 13) AI usage transparency

AI tools were actively used to accelerate:
- prompt drafting/iteration
- scaffolding and refactoring
- API and UI iteration

All generated output was reviewed and edited manually, and the final code is fully explainable and modifiable in live session.
