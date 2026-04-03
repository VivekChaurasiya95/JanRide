import { crowdReports } from '../data/mockData.js';

export function addCrowdReport({ stop_id, type, user_id }) {
  const report = {
    stop_id,
    type,
    user_id,
    timestamp: Date.now(),
    trustWeight: 0.5,
  };
  crowdReports.push(report);
  return report;
}

export function getCrowdReports() {
  return crowdReports;
}

