export function calculateTrustScore({
  userTrustScore = 0.5,
  reports,
  userId,
  stopId,
  now = Date.now(),
}) {
  const reliability = clamp(userTrustScore, 0, 1);
  const thirtyMinutesAgo = now - 30 * 60 * 1000;
  const sixtyMinutesAgo = now - 60 * 60 * 1000;

  const recentAtStop = reports.filter(
    (report) => report.stop_id === stopId && report.timestamp >= thirtyMinutesAgo,
  ).length;
  const recentByUser = reports.filter(
    (report) => report.user_id === userId && report.timestamp >= sixtyMinutesAgo,
  ).length;

  const recency = recentAtStop === 0 ? 0.3 : clamp(recentAtStop / 3, 0.3, 1);
  const frequency = clamp(1 - recentByUser / 8, 0.4, 1);

  const trustScore =
    0.5 * reliability +
    0.3 * recency +
    0.2 * frequency;

  return {
    trustScore: clamp(trustScore, 0, 1),
    factors: {
      reliability,
      recency,
      frequency,
    },
  };
}

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value));
}
