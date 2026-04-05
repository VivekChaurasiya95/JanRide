# JanRide Backend

Node.js + Express backend for JanRide rider app and admin data APIs.

## Endpoints

- `GET /health`
- `POST /v1/auth/otp/send`
- `POST /v1/auth/otp/verify`
- `POST /v1/auth/verify` (Firebase ID token exchange)
- `GET /v1/me` (auth)
- `PUT /v1/me/profile` (auth)
- `GET /v1/stops`
- `GET /v1/routes`
- `POST /v1/route-search`
- `POST /v1/crowd-report` (auth)
- `GET /v1/crowd-reports`
- `GET /v1/analytics/heatmap`
- `GET /v1/analytics/peak-hours`

## Run

```bash
cp .env.example .env
npm install
npm run dev
```

### Firebase Admin env required for `/v1/auth/verify`

- `FIREBASE_PROJECT_ID`
- `FIREBASE_CLIENT_EMAIL`
- `FIREBASE_PRIVATE_KEY` (use escaped new lines in `.env`)

## Smoke test

```bash
npm run smoke
```

## Notes

- OTP send/verify endpoint still exists for local backend testing.
- App login should exchange Firebase ID token at `/v1/auth/verify` to get JanRide `accessToken`.
- Data is currently in-memory mock storage to speed up integration.

