import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../services/api_service.dart';

class PermissionViewModel extends ChangeNotifier {
  PermissionViewModel([this._apiService]) {
    _init();
  }

  static const _permissionsOnboardedKey = 'permissions_onboarded';
  static const _locationEnabledKey = 'permission_location_enabled';
  static const _notificationsEnabledKey = 'permission_notifications_enabled';
  static const _pendingSyncLocationKey = 'pending_sync_location_enabled';
  static const _pendingSyncNotificationsKey =
      'pending_sync_notifications_enabled';

  final ApiService? _apiService;

  bool _locationEnabled = false;
  bool _notificationsEnabled = false;
  bool _locationGranted = false;
  bool _notificationsGranted = false;
  bool _isLoading = false;
  bool _isUpdatingLocation = false;
  bool _isUpdatingNotifications = false;
  bool _isDisposed = false;

  bool get locationEnabled => _locationEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get locationGranted => _locationGranted;
  bool get notificationsGranted => _notificationsGranted;
  bool get isLoading => _isLoading;
  bool get isUpdatingLocation => _isUpdatingLocation;
  bool get isUpdatingNotifications => _isUpdatingNotifications;

  Future<void> _init() async {
    if (_isDisposed) return;
    _locationGranted = await Permission.location.isGranted;
    if (_isDisposed) return;
    final notificationStatus = await Permission.notification.status;
    _notificationsGranted =
        notificationStatus.isGranted || notificationStatus.isProvisional;

    final prefs = await SharedPreferences.getInstance();
    if (_isDisposed) return;
    _locationEnabled = prefs.getBool(_locationEnabledKey) ?? _locationGranted;
    _notificationsEnabled =
        prefs.getBool(_notificationsEnabledKey) ?? _notificationsGranted;

    await _flushPendingSync();
    _safeNotifyListeners();
  }

  Future<bool> setLocationEnabled(bool value) async {
    if (_isUpdatingLocation) return false;

    var showGrantedPopup = false;
    final wasGranted = _locationGranted;

    _isUpdatingLocation = true;
    _safeNotifyListeners();
    try {
      _locationEnabled = value;
      if (value) {
        final status = await Permission.location.request();
        _locationGranted = status.isGranted;
      }

      showGrantedPopup = value && !wasGranted && _locationGranted;

      await _persistLocalPreference();
      unawaited(_syncPreferencesToBackend());
    } finally {
      _isUpdatingLocation = false;
      _safeNotifyListeners();
    }

    return showGrantedPopup;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    if (_isUpdatingNotifications) return;

    _isUpdatingNotifications = true;
    _safeNotifyListeners();
    try {
      _notificationsEnabled = value;
      if (value) {
        final status = await Permission.notification.request();
        _notificationsGranted = status.isGranted || status.isProvisional;
      }

      await _persistLocalPreference();
      unawaited(_syncPreferencesToBackend());
    } finally {
      _isUpdatingNotifications = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> requestAll() async {
    var showGrantedPopup = false;
    await _runWithLoading(() async {
      final wasLocationGranted = _locationGranted;

      Map<Permission, PermissionStatus> statuses;
      try {
        statuses = await [
          Permission.location,
          Permission.notification,
        ].request().timeout(const Duration(seconds: 8));
      } catch (_) {
        // Fallback keeps flow responsive if OS prompt API stalls.
        final locationStatus = await Permission.location.status;
        final notificationStatus = await Permission.notification.status;
        statuses = {
          Permission.location: locationStatus,
          Permission.notification: notificationStatus,
        };
      }

      _locationGranted = statuses[Permission.location]?.isGranted ?? false;
      _notificationsGranted =
          statuses[Permission.notification]?.isGranted == true ||
          statuses[Permission.notification]?.isProvisional == true;

      _locationEnabled = _locationGranted;
      _notificationsEnabled = _notificationsGranted;
      showGrantedPopup = !wasLocationGranted && _locationGranted;

      await markOnboardingComplete();
      await _persistLocalPreference();
      unawaited(_syncPreferencesToBackend());
    });

    return showGrantedPopup;
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionsOnboardedKey, true);
  }

  Future<void> _persistLocalPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationEnabledKey, _locationEnabled);
    await prefs.setBool(_notificationsEnabledKey, _notificationsEnabled);
  }

  Future<void> _syncPreferencesToBackend() async {
    if (_apiService == null) {
      return;
    }

    try {
      await _apiService.putJson(
        '/v1/me/preferences',
        body: {
          'locationEnabled': _locationEnabled,
          'notificationsEnabled': _notificationsEnabled,
          'locationPermissionGranted': _locationGranted,
          'notificationPermissionGranted': _notificationsGranted,
        },
      ).timeout(const Duration(seconds: 5));

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingSyncLocationKey);
      await prefs.remove(_pendingSyncNotificationsKey);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_pendingSyncLocationKey, _locationEnabled);
      await prefs.setBool(_pendingSyncNotificationsKey, _notificationsEnabled);
    }
  }

  Future<void> _flushPendingSync() async {
    if (_apiService == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_pendingSyncLocationKey) &&
        !prefs.containsKey(_pendingSyncNotificationsKey)) {
      return;
    }

    _locationEnabled =
        prefs.getBool(_pendingSyncLocationKey) ?? _locationEnabled;
    _notificationsEnabled =
        prefs.getBool(_pendingSyncNotificationsKey) ?? _notificationsEnabled;
    await _syncPreferencesToBackend();
  }

  Future<void> _runWithLoading(Future<void> Function() action) async {
    _isLoading = true;
    _safeNotifyListeners();
    try {
      await action();
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  void _safeNotifyListeners() {
    if (_isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
