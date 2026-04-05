import 'package:flutter/foundation.dart';

import '../models/ride_model.dart';
import '../services/api_service.dart';
import '../services/local_route_fallback_service.dart';

class RideViewModel extends ChangeNotifier {
  RideViewModel(this._apiService, {LocalRouteFallbackService? fallbackService})
	  : _fallbackService = fallbackService ?? const LocalRouteFallbackService();

  final ApiService _apiService;
  final LocalRouteFallbackService _fallbackService;

  bool isLoading = false;
  String? errorMessage;
  String? infoMessage;
  List<RideModel> routes = <RideModel>[];
  String? selectedFromStopName;
  String? selectedToStopName;
  String selectedPreference = 'fastest';

  Future<void> searchRoutes({
	required String fromStopId,
	required String toStopId,
	String preference = 'fastest',
	String? fromStopName,
	String? toStopName,
  }) async {
  selectedFromStopName = fromStopName;
  selectedToStopName = toStopName;
  selectedPreference = preference;
	errorMessage = null;
	infoMessage = null;
	isLoading = true;
	notifyListeners();

	try {
	  final response = await _apiService.postJson(
		'/v1/route-search',
		body: {
		  'from': fromStopId,
		  'to': toStopId,
		  'preference': preference,
		},
	  );

	  final rawRoutes = response['routes'] as List<dynamic>? ?? const [];
	  routes = rawRoutes.map((e) => RideModel.fromJson(e as Map<String, dynamic>)).toList();
	  if (routes.isEmpty) {
		routes = _fallbackService.searchRoutes(
		  fromStopId: fromStopId,
		  toStopId: toStopId,
		  preference: preference,
		);
		if (routes.isNotEmpty) {
		  infoMessage = 'Showing offline route estimates.';
		}
	  }
	} catch (e) {
	  routes = _fallbackService.searchRoutes(
		fromStopId: fromStopId,
		toStopId: toStopId,
		preference: preference,
	  );
	  if (routes.isNotEmpty) {
		infoMessage = 'Backend unavailable. Showing offline route estimates.';
		errorMessage = null;
	  } else {
		errorMessage = e.toString();
	  }
	} finally {
	  isLoading = false;
	  notifyListeners();
	}
  }
}

