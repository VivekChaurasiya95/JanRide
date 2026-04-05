import { crowdReports } from '../data/mockData.js';
import { calculateTrustScore } from '../algorithms/trustScore.js';

export function addCrowdReport({ stop_id, type, user_id, userTrustScore = 0.5 }) {
  const evaluation = calculateTrustScore({
    userTrustScore,
    reports: crowdReports,
    userId: user_id,
    stopId: stop_id,
  });

  const report = {
    stop_id,
    type,
    user_id,
    timestamp: Date.now(),
    trustWeight: Number(evaluation.trustScore.toFixed(3)),
    isValid: evaluation.trustScore >= 0.45,
    trustFactors: evaluation.factors,
  };
  crowdReports.push(report);
  return report;
}

export function getCrowdReports() {
  return [...crowdReports].sort((a, b) => b.timestamp - a.timestamp);
}

