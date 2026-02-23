# Dashboard

Next.js + Tailwind analytics dashboard for AI Recipe Assistant.

## Data Sources

- `GET /api/analytics/summary?days=7|30`
- `GET /api/requests/history?limit=120&includeRecipe=true`

## Panels

- KPI cards: total/success/failed/success rate/avg ingredient count
- Daily generation trend
- Top used ingredients (from `recognizedIngredients`)
- Success vs failed ratio
- Hourly request trend (`createdAt` hour)
- Input type distribution (`text` / `image` / `mixed`)
- Top failure codes (`errorCode`)
- Recent requests table (`recipe_requests` + `recipes` join)

## Run

```bash
cd dashboard
cp .env.example .env.local
npm install
npm run dev
```

Default URL: `http://localhost:3000`
