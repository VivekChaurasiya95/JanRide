# JanRide Backend

Node.js + Express backend for JanRide rider app APIs (auth, route search, crowd reports, analytics).

## Prerequisites

- Node.js 18+

## Setup and Run

```bash
cp .env.example .env
npm install
npm run dev
```

Default port is `5000`.

## Base Endpoints

- `GET /` -> basic API status response
- `GET /health` -> health check

## API Endpoints (`/v1`)

### Auth

- `POST /v1/auth/otp/send`
- `POST /v1/auth/otp/verify`
- `POST /v1/auth/verify` (Firebase ID token exchange)
- `GET /v1/me` (auth)
- `PUT /v1/me/profile` (auth)
- `PUT /v1/me/preferences` (auth)

### Transport

- `GET /v1/stops`
- `GET /v1/routes`
- `POST /v1/route-search`

### Crowd and Analytics

- `POST /v1/crowd-report` (auth)
- `GET /v1/crowd-reports`
- `GET /v1/analytics/heatmap`
- `GET /v1/analytics/peak-hours`

## Environment Variables

From `.env` (see `.env.example`):

- `PORT` (default: `5000`)
- `ALLOWED_ORIGIN` (default: `*`)
- `JWT_SECRET`
- `OTP_TTL_SECONDS`
- `DEV_OTP_CODE`

Firebase Admin variables (required for `/v1/auth/verify`):

- `FIREBASE_PROJECT_ID`
- `FIREBASE_CLIENT_EMAIL`
- `FIREBASE_PRIVATE_KEY` (escaped new lines in `.env`)

## Smoke Test

Run after backend is started:

```bash
npm run smoke
```

Smoke test uses `JANRIDE_API_BASE` if provided, else defaults to `http://localhost:5000`.

## Notes

- App primarily calls `/v1/*` endpoints.
- Legacy `/api/auth/*` routes are still mounted for compatibility.
- Route and stop data is currently in-memory mock data (Gwalior-focused) for development.

