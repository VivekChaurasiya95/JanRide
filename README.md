# JanRide App

JanRide is a Flutter rider app with a Node.js backend for city route discovery, OTP/Firebase auth flow, and route recommendations (`Sasta`, `Tez`, `Kam Badlav`).

## Project Structure

- `lib/` Flutter app source
  - `screens/` UI flows (auth, onboarding, home)
  - `viewmodels/` app state and API wiring
  - `services/` API, auth, location, and local route fallback
  - `models/` route and location data models
- `assets/images/` UI and map assets
- `backend/` Node.js API (`/v1/*`) with in-memory Gwalior dataset

## Prerequisites

- Flutter SDK + Android SDK
- Node.js 18+

## Backend Setup

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

Backend runs on port `5000` by default.

Health checks:
- `GET /health`
- `GET /`

## Flutter Setup

```bash
flutter pub get
```

### Run on Android Emulator

```bash
flutter run --dart-define=JANRIDE_API_BASE=http://10.0.2.2:5000
```

### Run on Real Android Device (same Wi-Fi as backend)

```bash
flutter run --dart-define=JANRIDE_API_BASE=http://<YOUR_PC_LAN_IP>:5000
```

## Route Search Behavior

- Users select source/destination from Gwalior stops.
- Preferences:
  - `Sasta` -> cheapest
  - `Tez` -> fastest
  - `Kam Badlav` -> fewest transfers
- Results screen shows:
  - recommended route cards
  - route distance and time
  - fare comparison for Auto, Shared Tempo, E-Rickshaw

## Offline/Fallback Behavior

- If `/v1/stops` is unavailable, app uses bundled Gwalior stops.
- If `/v1/route-search` fails or times out, app computes local fallback routes and still shows route suggestions.

## API Smoke Test

Run after backend is up:

```bash
cd backend
node scripts/smoke-test.mjs
```

## Auth Notes

- App supports Firebase token exchange via `/v1/auth/verify`.
- Dev OTP endpoints still exist for local API testing.

## Next Production Tasks

- Replace in-memory data with persistent storage (e.g., Firestore/Postgres).
- Add real-time transit and crowd updates.
- Add CI checks and deployment pipeline for app/backend.
