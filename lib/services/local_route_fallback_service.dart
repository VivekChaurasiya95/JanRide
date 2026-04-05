import '../data/gwalior_stops_fallback.dart';
import '../models/ride_model.dart';

class LocalRouteFallbackService {
  const LocalRouteFallbackService();

  List<RideModel> searchRoutes({
    required String fromStopId,
    required String toStopId,
    required String preference,
  }) {
    final graph = _buildGraph();
    final profiles = _profilesFor(preference);
    final candidates = <RideModel>[];

    for (final profile in profiles) {
      final solved = _solve(
        graph: graph,
        from: fromStopId,
        to: toStopId,
        alpha: profile.alpha,
        beta: profile.beta,
        gamma: profile.gamma,
      );
      if (solved == null) {
        continue;
      }

      final legs = solved.legs
          .map(
            (edge) => RideLegModel(
              fromStop: _stopName(edge.from),
              toStop: _stopName(edge.to),
              vehicle: edge.vehicle,
              fare: edge.fare,
              durationMinutes: edge.durationMinutes,
              distanceKm: edge.distanceKm,
            ),
          )
          .toList();

      candidates.add(
        RideModel(
          path: solved.path,
          totalFare: solved.totalFare,
          totalTimeMinutes: solved.totalTimeMinutes,
          totalDistanceKm: solved.totalDistanceKm,
          transfers: solved.transfers,
          legs: legs,
          profile: profile.name,
          recommendationReason: profile.reason,
          score: solved.score,
        ),
      );
    }

    final deduped = _dedupe(candidates);
    deduped.sort((a, b) => a.score.compareTo(b.score));
    return deduped;
  }

  Map<String, List<_Edge>> _buildGraph() {
    final graph = <String, List<_Edge>>{};
    for (final stop in gwaliorFallbackStops) {
      graph[stop.id] = <_Edge>[];
    }

    for (final edge in _edges) {
      graph.putIfAbsent(edge.from, () => <_Edge>[]).add(edge);
    }
    return graph;
  }

  List<RideModel> _dedupe(List<RideModel> routes) {
    final seen = <String>{};
    final deduped = <RideModel>[];
    for (final route in routes) {
      final vehicles = route.legs.map((e) => e.vehicle).join('>');
      final key = '${route.path.join('>')}|$vehicles';
      if (!seen.add(key)) {
        continue;
      }
      deduped.add(route);
    }
    return deduped;
  }

  _PathResult? _solve({
    required Map<String, List<_Edge>> graph,
    required String from,
    required String to,
    required double alpha,
    required double beta,
    required double gamma,
  }) {
    final nodes = graph.keys.toList();
    if (!graph.containsKey(from) || !graph.containsKey(to)) {
      return null;
    }

    final distances = <String, double>{for (final n in nodes) n: double.infinity};
    final previous = <String, ({String node, _Edge edge})>{};
    final queue = <String>{...nodes};
    distances[from] = 0;

    while (queue.isNotEmpty) {
      String? current;
      var minDistance = double.infinity;
      for (final node in queue) {
        final d = distances[node] ?? double.infinity;
        if (d < minDistance) {
          minDistance = d;
          current = node;
        }
      }
      if (current == null || minDistance == double.infinity) {
        break;
      }
      queue.remove(current);
      if (current == to) {
        break;
      }

      for (final edge in graph[current] ?? const <_Edge>[]) {
        final cost = alpha * edge.fare + beta * edge.durationMinutes + gamma;
        final nextDistance = (distances[current] ?? double.infinity) + cost;
        if (nextDistance < (distances[edge.to] ?? double.infinity)) {
          distances[edge.to] = nextDistance;
          previous[edge.to] = (node: current, edge: edge);
        }
      }
    }

    if (!previous.containsKey(to)) {
      return null;
    }

    final path = <String>[to];
    final legs = <_Edge>[];
    var cursor = to;
    while (previous.containsKey(cursor)) {
      final prev = previous[cursor]!;
      path.insert(0, prev.node);
      legs.insert(0, prev.edge);
      cursor = prev.node;
    }

    final totalFare = legs.fold<double>(0, (s, e) => s + e.fare);
    final totalTime = legs.fold<int>(0, (s, e) => s + e.durationMinutes);
    final totalDistance = legs.fold<double>(0, (s, e) => s + e.distanceKm);
    final transfers = (path.length - 2).clamp(0, 1000);

    return _PathResult(
      path: path,
      legs: legs,
      totalFare: totalFare,
      totalTimeMinutes: totalTime,
      totalDistanceKm: totalDistance,
      transfers: transfers,
      score: distances[to] ?? 0,
    );
  }

  List<_Profile> _profilesFor(String preference) {
    const allProfiles = <String, _Profile>{
      'balanced': _Profile('balanced', 'Balanced fare, travel time and transfers.', 1.2, 1.6, 1.4),
      'fastest': _Profile('fastest', 'Optimized for minimum travel time.', 1.0, 2.2, 1.3),
      'cheapest': _Profile('cheapest', 'Optimized for minimum fare.', 2.3, 0.9, 1.2),
      'fewest_transfers': _Profile('fewest_transfers', 'Optimized for fewer transfers.', 1.0, 1.3, 2.7),
    };

    const aliases = <String, String>{
      'sasta': 'cheapest',
      'tez': 'fastest',
      'kam_badlav': 'fewest_transfers',
    };

    final normalized = preference.toLowerCase();
    final primary = aliases[normalized] ?? normalized;
    final selected = allProfiles[primary] ?? allProfiles['balanced']!;
    return <_Profile>[
      selected,
      allProfiles['fastest']!,
      allProfiles['cheapest']!,
      allProfiles['fewest_transfers']!,
    ];
  }

  String _stopName(String stopId) {
    for (final stop in gwaliorFallbackStops) {
      if (stop.id == stopId) {
        return stop.name;
      }
    }
    return stopId;
  }
}

class _Edge {
  const _Edge({
    required this.from,
    required this.to,
    required this.vehicle,
    required this.fare,
    required this.durationMinutes,
    required this.distanceKm,
  });

  final String from;
  final String to;
  final String vehicle;
  final double fare;
  final int durationMinutes;
  final double distanceKm;
}

class _Profile {
  const _Profile(this.name, this.reason, this.alpha, this.beta, this.gamma);

  final String name;
  final String reason;
  final double alpha;
  final double beta;
  final double gamma;
}

class _PathResult {
  const _PathResult({
    required this.path,
    required this.legs,
    required this.totalFare,
    required this.totalTimeMinutes,
    required this.totalDistanceKm,
    required this.transfers,
    required this.score,
  });

  final List<String> path;
  final List<_Edge> legs;
  final double totalFare;
  final int totalTimeMinutes;
  final double totalDistanceKm;
  final int transfers;
  final double score;
}

const List<_Edge> _edges = <_Edge>[
  _Edge(from: 'S1', to: 'S2', vehicle: 'Vikram (Tempo)', fare: 15, durationMinutes: 32, distanceKm: 4.69),
  _Edge(from: 'S1', to: 'S3', vehicle: 'Tata Magic', fare: 20, durationMinutes: 41, distanceKm: 5.71),
  _Edge(from: 'S1', to: 'S4', vehicle: 'Vikram (Tempo)', fare: 15, durationMinutes: 45, distanceKm: 7.79),
  _Edge(from: 'S5', to: 'S6', vehicle: 'City Bus (Sutrasewa)', fare: 10, durationMinutes: 35, distanceKm: 2.56),
  _Edge(from: 'S5', to: 'S8', vehicle: 'Auto-Rickshaw', fare: 50, durationMinutes: 15, distanceKm: 1.55),
  _Edge(from: 'S5', to: 'S1', vehicle: 'Tata Magic', fare: 20, durationMinutes: 31, distanceKm: 3.52),
  _Edge(from: 'S6', to: 'S7', vehicle: 'Auto-Rickshaw', fare: 55, durationMinutes: 27, distanceKm: 4.54),
  _Edge(from: 'S6', to: 'S8', vehicle: 'Tata Magic', fare: 15, durationMinutes: 19, distanceKm: 1.42),
  _Edge(from: 'S6', to: 'S4', vehicle: 'Auto-Rickshaw', fare: 55, durationMinutes: 35, distanceKm: 6.23),
  _Edge(from: 'S2', to: 'S4', vehicle: 'City Bus (Sutrasewa)', fare: 15, durationMinutes: 42, distanceKm: 5.27),
  _Edge(from: 'S2', to: 'S1', vehicle: 'Vikram (Tempo)', fare: 15, durationMinutes: 30, distanceKm: 4.69),
  _Edge(from: 'S2', to: 'S5', vehicle: 'City Bus (Sutrasewa)', fare: 10, durationMinutes: 30, distanceKm: 2.75),
  _Edge(from: 'S3', to: 'S8', vehicle: 'Tata Magic', fare: 20, durationMinutes: 35, distanceKm: 3.92),
  _Edge(from: 'S3', to: 'S1', vehicle: 'Vikram (Tempo)', fare: 15, durationMinutes: 35, distanceKm: 5.71),
  _Edge(from: 'S3', to: 'S5', vehicle: 'Auto-Rickshaw', fare: 50, durationMinutes: 16, distanceKm: 2.37),
  _Edge(from: 'S7', to: 'S3', vehicle: 'City Bus (Sutrasewa)', fare: 10, durationMinutes: 37, distanceKm: 2.72),
  _Edge(from: 'S7', to: 'S4', vehicle: 'City Bus (Sutrasewa)', fare: 10, durationMinutes: 30, distanceKm: 2.31),
  _Edge(from: 'S7', to: 'S2', vehicle: 'Vikram (Tempo)', fare: 15, durationMinutes: 26, distanceKm: 3.25),
  _Edge(from: 'S8', to: 'S5', vehicle: 'Auto-Rickshaw', fare: 50, durationMinutes: 14, distanceKm: 1.55),
  _Edge(from: 'S8', to: 'S7', vehicle: 'Vikram (Tempo)', fare: 15, durationMinutes: 26, distanceKm: 4.54),
  _Edge(from: 'S8', to: 'S2', vehicle: 'City Bus (Sutrasewa)', fare: 10, durationMinutes: 31, distanceKm: 2.49),
  _Edge(from: 'S4', to: 'S2', vehicle: 'Auto-Rickshaw', fare: 55, durationMinutes: 28, distanceKm: 5.27),
  _Edge(from: 'S4', to: 'S8', vehicle: 'Vikram (Tempo)', fare: 15, durationMinutes: 31, distanceKm: 5.76),
  _Edge(from: 'S4', to: 'S7', vehicle: 'Auto-Rickshaw', fare: 50, durationMinutes: 23, distanceKm: 2.31),
];

