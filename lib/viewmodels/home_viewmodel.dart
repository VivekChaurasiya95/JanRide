import 'package:flutter/foundation.dart';

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
	try {
	  currentLocation = await _locationService.getCurrentApproxLocation();
	  final response = await _apiService.getJson('/v1/stops');
	  final rawStops = response['stops'] as List<dynamic>? ?? const [];
	  stops = rawStops.map((e) => LocationModel.fromJson(e as Map<String, dynamic>)).toList();
	  errorMessage = null;
	} catch (e) {
	  errorMessage = e.toString();
	} finally {
	  isLoading = false;
	  notifyListeners();
	}
  }
}

