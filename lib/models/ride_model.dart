class RideLegModel {
  const RideLegModel({
	required this.fromStop,
	required this.toStop,
	required this.vehicle,
	required this.fare,
	required this.durationMinutes,
  });

  final String fromStop;
  final String toStop;
  final String vehicle;
  final double fare;
  final int durationMinutes;

  factory RideLegModel.fromJson(Map<String, dynamic> json) {
	return RideLegModel(
	  fromStop: json['fromStop']?.toString() ?? '',
	  toStop: json['toStop']?.toString() ?? '',
	  vehicle: json['vehicle']?.toString() ?? 'tempo',
	  fare: (json['fare'] as num?)?.toDouble() ?? 0,
	  durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
	);
  }

  Map<String, dynamic> toJson() {
	return {
	  'fromStop': fromStop,
	  'toStop': toStop,
	  'vehicle': vehicle,
	  'fare': fare,
	  'durationMinutes': durationMinutes,
	};
  }
}

class RideModel {
  const RideModel({
	required this.path,
	required this.totalFare,
	required this.totalTimeMinutes,
	required this.transfers,
	required this.legs,
	this.score = 0,
  });

  final List<String> path;
  final double totalFare;
  final int totalTimeMinutes;
  final int transfers;
  final List<RideLegModel> legs;
  final double score;

  factory RideModel.fromJson(Map<String, dynamic> json) {
	final legsRaw = (json['legs'] as List<dynamic>? ?? const []);
	return RideModel(
	  path: (json['path'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
	  totalFare: (json['totalFare'] as num?)?.toDouble() ?? 0,
	  totalTimeMinutes: (json['totalTimeMinutes'] as num?)?.toInt() ?? 0,
	  transfers: (json['transfers'] as num?)?.toInt() ?? 0,
	  legs: legsRaw.map((e) => RideLegModel.fromJson(e as Map<String, dynamic>)).toList(),
	  score: (json['score'] as num?)?.toDouble() ?? 0,
	);
  }

  Map<String, dynamic> toJson() {
	return {
	  'path': path,
	  'totalFare': totalFare,
	  'totalTimeMinutes': totalTimeMinutes,
	  'transfers': transfers,
	  'score': score,
	  'legs': legs.map((e) => e.toJson()).toList(),
	};
  }
}

