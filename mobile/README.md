# Recipe Assistant (Mobile)

Flutter client for AI Recipe Assistant.

The mobile app does not call Gemini directly.
It calls backend API endpoints:

- `POST /api/ingredients/recognize`
- `POST /api/recipes/generate`

## Run

1. Install packages:
   - `flutter pub get`
2. Start backend first (`../backend`).
3. Run mobile app:
   - Android emulator: `flutter run`
   - Custom backend URL: `flutter run --dart-define=API_BASE_URL=http://YOUR_IP:3001/api`

## Notes

- Default API base URL is `http://10.0.2.2:3001/api` (Android emulator -> host machine).
- State management: `flutter_bloc`.
- UI flow: text/image input -> ingredient recognition -> recipe generation.
