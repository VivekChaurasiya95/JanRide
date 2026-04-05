# JanRide App

JanRide - Solving Intra-City Last Mile Connectivity through a Unified Public Transport Intelligence Platform.

JanRide is a Flutter rider app wired to a Node.js backend with route search, OTP login flow, profile setup, and mobility APIs.

## Project Structure

- `lib/` Flutter mobile app (screens, viewmodels, services, models)
- `backend/` Node.js API service (`/v1/*` endpoints)

## Flutter Setup

1. Install Flutter SDK and Android SDK.
2. Install app dependencies.
3. Run the app with backend base URL.

```bash
flutter pub get
flutter run --dart-define=JANRIDE_API_BASE=http://10.0.2.2:5000
```

## Backend Setup

1. Install Node.js 18+.
2. Configure environment file.
3. Install backend dependencies and start server.

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

## API Smoke Test

Start backend first, then run:

```bash
cd backend
node scripts/smoke-test.mjs
```

## Current Auth Mode

- Mobile OTP is verified by Firebase Auth on the app.
- App exchanges Firebase ID token with backend `/v1/auth/verify` to receive JanRide access token.
- Backend still keeps dev OTP endpoints for local-only API testing.

## Next Production Tasks

- Keep Firebase Auth config in sync (`google-services.json`, Android SHA keys, backend Admin credentials).
- Replace mock/in-memory backend stores with Firestore collections.
- Add FCM push notifications and real-time crowd updates.
