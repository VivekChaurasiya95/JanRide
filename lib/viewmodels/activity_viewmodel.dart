import 'package:flutter/foundation.dart';

import '../models/activity_model.dart';
import '../services/activity_service.dart';

class ActivityViewModel extends ChangeNotifier {
  ActivityViewModel(this._activityService);

  final ActivityService _activityService;

  bool isLoading = false;
  bool isHistoryLoading = false;
  bool isStartingTrip = false;
  String? errorMessage;
  String? infoMessage;

  ActivitySummaryModel summary = const ActivitySummaryModel(
    tripsTaken: 0,
    tripsChangePercent: 0,
    moneySaved: 0,
    moneySavedChangePercent: 0,
    carbonKg: 0,
    carbonMonthlyTargetKg: 20,
    carbonPercentOfLimit: 0,
    carbonWeeklySavedKg: 0,
  );

  ReferralModel referral = const ReferralModel(
    title: 'Refer & Earn',
    body: 'Invite friends to JanRide and get credits.',
    rewardAmount: 0,
  );

  List<FavoriteRouteModel> favoriteRoutes = const <FavoriteRouteModel>[];
  List<ActivityHistoryItemModel> history = const <ActivityHistoryItemModel>[];

  Future<void> loadDashboard() async {
    isLoading = true;
    errorMessage = null;
    infoMessage = null;
    notifyListeners();

    try {
      final data = await _activityService.fetchDashboard();
      summary = data.summary;
      referral = data.referral;
      favoriteRoutes = data.favoriteRoutes;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    isHistoryLoading = true;
    errorMessage = null;
    infoMessage = null;
    notifyListeners();

    try {
      history = await _activityService.fetchHistory();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isHistoryLoading = false;
      notifyListeners();
    }
  }

  Future<bool> startTrip(String routeId) async {
    isStartingTrip = true;
    errorMessage = null;
    infoMessage = null;
    notifyListeners();

    try {
      await _activityService.startTrip(routeId);
      return true;
    } catch (e) {
      final message = e.toString();
      final isNetworkIssue =
          message.contains('Cannot reach backend') ||
          message.contains('timed out') ||
          message.contains('SocketException');

      if (isNetworkIssue) {
        infoMessage = 'Backend is unavailable. Trip started in offline mode.';
        errorMessage = null;
        return true;
      }

      errorMessage = message;
      return false;
    } finally {
      isStartingTrip = false;
      notifyListeners();
    }
  }
}

