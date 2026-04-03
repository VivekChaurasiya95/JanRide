class LocationModel {
  const LocationModel({
	required this.id,
	required this.name,
	required this.lat,
	required this.lng,
	this.city,
	this.landmark,
  });

  final String id;
  final String name;
  final double lat;
  final double lng;
  final String? city;
  final String? landmark;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
	return LocationModel(
	  id: json['id']?.toString() ?? '',
	  name: json['name']?.toString() ?? '',
	  lat: (json['lat'] as num?)?.toDouble() ?? 0,
	  lng: (json['lng'] as num?)?.toDouble() ?? 0,
	  city: json['city']?.toString(),
	  landmark: json['landmark']?.toString(),
	);
  }

  Map<String, dynamic> toJson() {
	return {
	  'id': id,
	  'name': name,
	  'lat': lat,
	  'lng': lng,
	  'city': city,
	  'landmark': landmark,
	};
  }
}

