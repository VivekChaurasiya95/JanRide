import '../models/activity_model.dart';
import 'api_service.dart';

class ActivityService {
  ActivityService(this._apiService);

  final ApiService _apiService;

  Future<({ActivitySummaryModel summary, ReferralModel referral, List<FavoriteRouteModel> favoriteRoutes})> fetchDashboard() async {
    final response = await _apiService.getJson('/v1/activity/dashboard');
    final summary = ActivitySummaryModel.fromJson(response['summary'] as Map<String, dynamic>? ?? const {});
    final referral = ReferralModel.fromJson(response['referral'] as Map<String, dynamic>? ?? const {});
    final rawRoutes = response['favoriteRoutes'] as List<dynamic>? ?? const [];
    final favoriteRoutes = rawRoutes
        .map((e) => FavoriteRouteModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return (summary: summary, referral: referral, favoriteRoutes: favoriteRoutes);
  }

  Future<List<ActivityHistoryItemModel>> fetchHistory() async {
    final response = await _apiService.getJson('/v1/activity/history');
    final rawHistory = response['history'] as List<dynamic>? ?? const [];
    return rawHistory
        .map((e) => ActivityHistoryItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> startTrip(String routeId) async {
    return _apiService.postJson(
      '/v1/activity/start-trip',
      body: {'routeId': routeId},
    );
  }
}

