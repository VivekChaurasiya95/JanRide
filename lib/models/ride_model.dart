class RideLegModel {
  const RideLegModel({
	required this.fromStop,
	required this.toStop,
	required this.vehicle,
	required this.fare,
	required this.durationMinutes,
    required this.distanceKm,
  });

  final String fromStop;
  final String toStop;
  final String vehicle;
  final double fare;
  final int durationMinutes;
  final double distanceKm;

  factory RideLegModel.fromJson(Map<String, dynamic> json) {
	return RideLegModel(
	  fromStop: json['fromStop']?.toString() ?? '',
	  toStop: json['toStop']?.toString() ?? '',
	  vehicle: json['vehicle']?.toString() ?? 'tempo',
	  fare: (json['fare'] as num?)?.toDouble() ?? 0,
	  durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
	);
  }

  Map<String, dynamic> toJson() {
	return {
	  'fromStop': fromStop,
	  'toStop': toStop,
	  'vehicle': vehicle,
	  'fare': fare,
	  'durationMinutes': durationMinutes,
      'distanceKm': distanceKm,
	};
  }
}

class RideModel {
  const RideModel({
	required this.path,
	required this.totalFare,
	required this.totalTimeMinutes,
	required this.totalDistanceKm,
	required this.transfers,
	required this.legs,
	required this.profile,
	required this.recommendationReason,
	this.score = 0,
  });

  final List<String> path;
  final double totalFare;
  final int totalTimeMinutes;
  final double totalDistanceKm;
  final int transfers;
  final List<RideLegModel> legs;
  final String profile;
  final String recommendationReason;
  final double score;

  factory RideModel.fromJson(Map<String, dynamic> json) {
	final legsRaw = (json['legs'] as List<dynamic>? ?? const []);
	return RideModel(
	  path: (json['path'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
	  totalFare: (json['totalFare'] as num?)?.toDouble() ?? 0,
	  totalTimeMinutes: (json['totalTimeMinutes'] as num?)?.toInt() ?? 0,
	  totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble() ?? 0,
	  transfers: (json['transfers'] as num?)?.toInt() ?? 0,
	  legs: legsRaw.map((e) => RideLegModel.fromJson(e as Map<String, dynamic>)).toList(),
	  profile: json['profile']?.toString() ?? 'balanced',
	  recommendationReason: json['recommendationReason']?.toString() ?? '',
	  score: (json['score'] as num?)?.toDouble() ?? 0,
	);
  }

  Map<String, dynamic> toJson() {
	return {
	  'path': path,
	  'totalFare': totalFare,
	  'totalTimeMinutes': totalTimeMinutes,
	  'totalDistanceKm': totalDistanceKm,
	  'transfers': transfers,
	  'profile': profile,
	  'recommendationReason': recommendationReason,
	  'score': score,
	  'legs': legs.map((e) => e.toJson()).toList(),
	};
  }
}

