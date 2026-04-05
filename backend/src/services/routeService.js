import { findBestRoute } from '../algorithms/dijkstra.js';
import { routes, stops } from '../data/mockData.js';
import { HttpError } from '../utils/httpError.js';

export function getStops() {
  return stops;
}

export function getRoutes() {
  return routes;
}

export function searchRoute({ from, to, preference }) {
  const fromStop = stops.find((s) => s.id === from);
  const toStop = stops.find((s) => s.id === to);
  if (!fromStop || !toStop) {
    throw new HttpError(400, 'Invalid stop ids for route search');
  }

  const graph = buildGraph();
  const profiles = getSearchProfiles(preference);
  const candidates = profiles
    .map((profile) => {
      const best = findBestRoute({
        graph,
        from,
        to,
        alpha: profile.alpha,
        beta: profile.beta,
        gamma: profile.gamma,
        delta: profile.delta,
      });
      if (!best) {
        return null;
      }

      return {
        profile: profile.name,
        recommendationReason: profile.reason,
        path: best.path,
        totalFare: best.totalFare,
        totalTimeMinutes: best.totalTimeMinutes,
        totalDistanceKm: best.totalDistanceKm,
        transfers: best.transfers,
        score: best.score,
        objectiveBreakdown: best.objectiveBreakdown,
        weights: {
          fare: profile.alpha,
          time: profile.beta,
          transfers: profile.gamma,
          crowd: profile.delta,
        },
        legs: best.legs.map((leg) => ({
          fromStop: stopName(leg.from),
          toStop: stopName(leg.to),
          vehicle: leg.vehicle,
          fare: leg.fare,
          durationMinutes: leg.durationMinutes,
          distanceKm: leg.distanceKm,
        })),
      };
    })
    .filter(Boolean);

  if (candidates.length === 0) {
    return [];
  }

  const deduped = dedupeCandidates(candidates);
  deduped.sort((a, b) => a.score - b.score);
  return deduped;
}

function buildGraph() {
  const graph = new Map();
  for (const stop of stops) {
    graph.set(stop.id, []);
  }

  for (const route of routes) {
    for (const leg of route.legs) {
      const edge = {
        from: leg.from,
        to: leg.to,
        vehicle: route.vehicle,
        fare: leg.fare,
        durationMinutes: leg.durationMinutes,
        distanceKm: leg.distanceKm ?? 0,
        transferPenalty: 1,
        crowdPenalty: crowdPenaltyByVehicle(route.vehicle),
      };
      graph.get(leg.from).push(edge);
    }
  }

  return graph;
}

function getSearchProfiles(preference) {
  const normalized = (preference ?? 'balanced').toLowerCase();
  const allProfiles = {
    balanced: {
      name: 'balanced',
      reason: 'Balanced fare, travel time and transfers.',
      alpha: 1.2,
      beta: 1.6,
      gamma: 1.4,
      delta: 0.8,
    },
    fastest: {
      name: 'fastest',
      reason: 'Optimized for minimum travel time.',
      alpha: 1.0,
      beta: 2.2,
      gamma: 1.3,
      delta: 0.8,
    },
    cheapest: {
      name: 'cheapest',
      reason: 'Optimized for minimum fare.',
      alpha: 2.3,
      beta: 0.9,
      gamma: 1.2,
      delta: 0.7,
    },
    fewest_transfers: {
      name: 'fewest_transfers',
      reason: 'Optimized for fewer transfers.',
      alpha: 1.0,
      beta: 1.3,
      gamma: 2.7,
      delta: 0.7,
    },
  };

  const aliases = {
    sasta: 'cheapest',
    tez: 'fastest',
    kam_badlav: 'fewest_transfers',
  };

  const primary = aliases[normalized] ?? normalized;
  const selected = allProfiles[primary] ?? allProfiles.balanced;

  return [
    selected,
    allProfiles.fastest,
    allProfiles.cheapest,
    allProfiles.fewest_transfers,
  ];
}

function dedupeCandidates(candidates) {
  const seen = new Set();
  const output = [];
  for (const candidate of candidates) {
    const key = `${candidate.path.join('>')}|${candidate.legs.map((leg) => leg.vehicle).join('>')}`;
    if (seen.has(key)) {
      continue;
    }
    seen.add(key);
    output.push(candidate);
  }
  return output;
}

function crowdPenaltyByVehicle(vehicle) {
  const normalized = vehicle.toLowerCase();
  switch (normalized) {
    case 'tempo':
    case 'vikram (tempo)':
      return 1.2;
    case 'auto':
    case 'auto-rickshaw':
      return 0.9;
    case 'e-rickshaw':
      return 1.0;
    case 'city bus (sutrasewa)':
      return 1.1;
    case 'tata magic':
      return 1.05;
    default:
      return normalized.includes('bus') ? 1.1 : 1.0;
  }
}

function stopName(stopId) {
  return stops.find((stop) => stop.id === stopId)?.name ?? stopId;
}

