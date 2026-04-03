const baseUrl = process.env.JANRIDE_API_BASE ?? 'http://localhost:8080';

async function run() {
  const health = await fetchJson('/health');
  const otpSend = await fetchJson('/v1/auth/otp/send', {
    method: 'POST',
    body: JSON.stringify({ phoneE164: '+919876543210' }),
  });

  const otpVerify = await fetchJson('/v1/auth/otp/verify', {
    method: 'POST',
    body: JSON.stringify({
      phoneE164: '+919876543210',
      verificationId: otpSend.verificationId,
      otpCode: otpSend.debugOtpCode,
    }),
  });

  const token = otpVerify.accessToken;
  const me = await fetchJson('/v1/me', {
    headers: { Authorization: `Bearer ${token}` },
  });

  const routeSearch = await fetchJson('/v1/route-search', {
    method: 'POST',
    body: JSON.stringify({ from: 'S1', to: 'S2', preference: 'fastest' }),
  });

  console.log('Smoke test passed');
  console.log({
    health,
    userId: me.user.id,
    routeCount: routeSearch.routes.length,
  });
}

async function fetchJson(path, init = {}) {
  const response = await fetch(`${baseUrl}${path}`, {
    ...init,
    headers: {
      'Content-Type': 'application/json',
      ...(init.headers ?? {}),
    },
  });
  const body = await response.json();
  if (!response.ok) {
    throw new Error(`${response.status} ${body.message}`);
  }
  return body;
}

run().catch((error) => {
  console.error('Smoke test failed:', error.message);
  process.exit(1);
});

