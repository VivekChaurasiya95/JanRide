import 'package:flutter/foundation.dart';

import '../models/ride_model.dart';
import '../services/api_service.dart';

class RideViewModel extends ChangeNotifier {
  RideViewModel(this._apiService);

  final ApiService _apiService;

  bool isLoading = false;
  String? errorMessage;
  List<RideModel> routes = <RideModel>[];

  Future<void> searchRoutes({
	required String fromStopId,
	required String toStopId,
	String preference = 'fastest',
  }) async {
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
	  errorMessage = null;
	} catch (e) {
	  errorMessage = e.toString();
	  routes = <RideModel>[];
	} finally {
	  isLoading = false;
	  notifyListeners();
	}
  }
}

