class ActivitySummaryModel {
  const ActivitySummaryModel({
    required this.tripsTaken,
    required this.tripsChangePercent,
    required this.moneySaved,
    required this.moneySavedChangePercent,
    required this.carbonKg,
    required this.carbonMonthlyTargetKg,
    required this.carbonPercentOfLimit,
    required this.carbonWeeklySavedKg,
  });

  final int tripsTaken;
  final int tripsChangePercent;
  final double moneySaved;
  final int moneySavedChangePercent;
  final double carbonKg;
  final double carbonMonthlyTargetKg;
  final int carbonPercentOfLimit;
  final double carbonWeeklySavedKg;

  factory ActivitySummaryModel.fromJson(Map<String, dynamic> json) {
    return ActivitySummaryModel(
      tripsTaken: (json['tripsTaken'] as num?)?.toInt() ?? 0,
      tripsChangePercent: (json['tripsChangePercent'] as num?)?.toInt() ?? 0,
      moneySaved: (json['moneySaved'] as num?)?.toDouble() ?? 0,
      moneySavedChangePercent: (json['moneySavedChangePercent'] as num?)?.toInt() ?? 0,
      carbonKg: (json['carbonKg'] as num?)?.toDouble() ?? 0,
      carbonMonthlyTargetKg: (json['carbonMonthlyTargetKg'] as num?)?.toDouble() ?? 0,
      carbonPercentOfLimit: (json['carbonPercentOfLimit'] as num?)?.toInt() ?? 0,
      carbonWeeklySavedKg: (json['carbonWeeklySavedKg'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ReferralModel {
  const ReferralModel({
    required this.title,
    required this.body,
    required this.rewardAmount,
  });

  final String title;
  final String body;
  final int rewardAmount;

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      title: json['title']?.toString() ?? 'Refer & Earn',
      body: json['body']?.toString() ?? '',
      rewardAmount: (json['rewardAmount'] as num?)?.toInt() ?? 0,
    );
  }
}

class FavoriteRouteModel {
  const FavoriteRouteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fareRange,
    required this.status,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String fareRange;
  final String status;
  final String icon;

  factory FavoriteRouteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteRouteModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      fareRange: json['fareRange']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'route',
    );
  }
}

class ActivityHistoryItemModel {
  const ActivityHistoryItemModel({
    required this.id,
    required this.routeTitle,
    required this.dateLabel,
    required this.fare,
    required this.durationLabel,
    required this.status,
  });

  final String id;
  final String routeTitle;
  final String dateLabel;
  final double fare;
  final String durationLabel;
  final String status;

  factory ActivityHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ActivityHistoryItemModel(
      id: json['id']?.toString() ?? '',
      routeTitle: json['routeTitle']?.toString() ?? '',
      dateLabel: json['dateLabel']?.toString() ?? '',
      fare: (json['fare'] as num?)?.toDouble() ?? 0,
      durationLabel: json['durationLabel']?.toString() ?? '',
      status: json['status']?.toString() ?? 'completed',
    );
  }
}

