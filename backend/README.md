# JanRide Backend

Node.js + Express backend for JanRide rider app and admin data APIs.

## Endpoints

- `GET /health`
- `POST /v1/auth/otp/send`
- `POST /v1/auth/otp/verify`
- `POST /v1/auth/verify` (dev token mode)
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

## Smoke test

```bash
npm run smoke
```

## Notes

- Current auth is dev-friendly OTP and `dev-*` Google token mode.
- Replace with Firebase Admin verification for production.
- Data is currently in-memory mock storage to speed up integration.

