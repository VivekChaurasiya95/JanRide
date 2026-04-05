export function findBestRoute({
  graph,
  from,
  to,
  alpha = 1,
  beta = 1,
  gamma = 1,
  delta = 0,
}) {
  const distances = new Map();
  const previous = new Map();
  const queue = new Set();

  for (const node of graph.keys()) {
    distances.set(node, Infinity);
    queue.add(node);
  }
  distances.set(from, 0);

  while (queue.size > 0) {
    const current = getLowestDistanceNode(queue, distances);
    if (!current) break;
    queue.delete(current);

    if (current === to) {
      break;
    }

    const edges = graph.get(current) ?? [];
    for (const edge of edges) {
      const cost =
        alpha * edge.fare +
        beta * edge.durationMinutes +
        gamma * edge.transferPenalty +
        delta * (edge.crowdPenalty ?? 0);
      const nextDistance = (distances.get(current) ?? Infinity) + cost;
      if (nextDistance < (distances.get(edge.to) ?? Infinity)) {
        distances.set(edge.to, nextDistance);
        previous.set(edge.to, { node: current, edge });
      }
    }
  }

  if (!previous.has(to)) {
    return null;
  }

  const path = [to];
  const legs = [];
  let cursor = to;
  while (previous.has(cursor)) {
    const prev = previous.get(cursor);
    path.unshift(prev.node);
    legs.unshift(prev.edge);
    cursor = prev.node;
  }

  const totalFare = legs.reduce((sum, leg) => sum + leg.fare, 0);
  const totalTimeMinutes = legs.reduce((sum, leg) => sum + leg.durationMinutes, 0);
  const totalDistanceKm = legs.reduce((sum, leg) => sum + (leg.distanceKm ?? 0), 0);
  const totalTransferPenalty = legs.reduce((sum, leg) => sum + (leg.transferPenalty ?? 1), 0);
  const totalCrowdPenalty = legs.reduce((sum, leg) => sum + (leg.crowdPenalty ?? 0), 0);
  const transfers = Math.max(path.length - 2, 0);

  return {
    path,
    legs,
    totalFare,
    totalTimeMinutes,
    totalDistanceKm,
    transfers,
    totalTransferPenalty,
    totalCrowdPenalty,
    objectiveBreakdown: {
      fare: totalFare,
      timeMinutes: totalTimeMinutes,
      transfers,
      transferPenalty: totalTransferPenalty,
      crowdPenalty: totalCrowdPenalty,
      weightedCost:
        alpha * totalFare +
        beta * totalTimeMinutes +
        gamma * totalTransferPenalty +
        delta * totalCrowdPenalty,
    },
    score: distances.get(to) ?? 0,
  };
}

function getLowestDistanceNode(queue, distances) {
  let minNode = null;
  let minDistance = Infinity;
  for (const node of queue) {
    const distance = distances.get(node) ?? Infinity;
    if (distance < minDistance) {
      minDistance = distance;
      minNode = node;
    }
  }
  return minNode;
}

