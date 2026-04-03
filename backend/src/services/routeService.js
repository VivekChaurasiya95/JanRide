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
  const weights = getWeights(preference);
  const best = findBestRoute({
    graph,
    from,
    to,
    alpha: weights.alpha,
    beta: weights.beta,
    gamma: weights.gamma,
  });

  if (!best) {
    return [];
  }

  return [
    {
      path: best.path,
      totalFare: best.totalFare,
      totalTimeMinutes: best.totalTimeMinutes,
      transfers: best.transfers,
      score: best.score,
      legs: best.legs.map((leg) => ({
        fromStop: stopName(leg.from),
        toStop: stopName(leg.to),
        vehicle: leg.vehicle,
        fare: leg.fare,
        durationMinutes: leg.durationMinutes,
      })),
    },
  ];
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
        transferPenalty: 1,
      };
      graph.get(leg.from).push(edge);
      graph.get(leg.to).push({ ...edge, from: leg.to, to: leg.from });
    }
  }

  return graph;
}

function getWeights(preference) {
  switch ((preference ?? 'fastest').toLowerCase()) {
    case 'cheapest':
    case 'sasta':
      return { alpha: 2.2, beta: 0.9, gamma: 1.4 };
    case 'fewest_transfers':
    case 'kam_badlav':
      return { alpha: 1.2, beta: 1.2, gamma: 2.6 };
    default:
      return { alpha: 1.2, beta: 1.8, gamma: 1.2 };
  }
}

function stopName(stopId) {
  return stops.find((stop) => stop.id === stopId)?.name ?? stopId;
}

