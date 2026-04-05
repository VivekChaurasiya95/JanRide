import 'package:flutter/foundation.dart';

import '../data/gwalior_stops_fallback.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._apiService, this._locationService);

  final ApiService _apiService;
  final LocationService _locationService;

  bool isLoading = false;
  String? errorMessage;
  LocationModel? currentLocation;
  List<LocationModel> stops = <LocationModel>[];

  Future<void> initialize() async {
	isLoading = true;
	notifyListeners();
	errorMessage = null;
	try {
	  try {
		currentLocation = await _locationService.getCurrentApproxLocation();
	  } catch (_) {
		// Location can fail on simulator/device permissions; stop loading should still proceed.
	  }

	  final response = await _apiService.getJson('/v1/stops');
	  final rawStops = response['stops'] as List<dynamic>? ?? const [];
	  final fetchedStops = rawStops.map((e) => LocationModel.fromJson(e as Map<String, dynamic>)).where((s) => s.id.isNotEmpty).toList();

	  if (fetchedStops.isNotEmpty) {
		stops = fetchedStops;
	  } else {
		stops = List<LocationModel>.from(gwaliorFallbackStops);
	  }
	} catch (e) {
	  // Fall back to bundled Gwalior stops so search UI stays usable even if backend is down.
	  stops = List<LocationModel>.from(gwaliorFallbackStops);
	  errorMessage = 'Using offline Gwalior stops.';
	} finally {
	  isLoading = false;
	  notifyListeners();
	}
  }
}

