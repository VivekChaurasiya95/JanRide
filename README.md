# JanRide App

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
flutter run --dart-define=JANRIDE_API_BASE=http://10.0.2.2:8080
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

- OTP flow is wired end-to-end for development.
- Default dev OTP code is `123456` (from `.env`).
- Google login currently uses dev token handshake and should be replaced with Firebase Auth ID token verification for production.

## Next Production Tasks

- Integrate Firebase Auth (`google-services.json`, Android SHA keys, ID token exchange).
- Replace mock/in-memory backend stores with Firestore collections.
- Add FCM push notifications and real-time crowd updates.
