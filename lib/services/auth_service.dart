import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import 'api_service.dart';

class AuthResult {
  const AuthResult({
	required this.user,
	required this.accessToken,
	required this.profileCompleted,
  });

  final UserModel user;
  final String accessToken;
  final bool profileCompleted;
}

class AuthService {
  AuthService(this._apiService);

  static const _tokenKey = 'janride_access_token';
  static const _userNameKey = 'janride_user_name';
  static const _locationEnabledKey = 'permission_location_enabled';
  static const _notificationsEnabledKey = 'permission_notifications_enabled';
  static const _pendingSyncLocationKey = 'pending_sync_location_enabled';
  static const _pendingSyncNotificationsKey =
	  'pending_sync_notifications_enabled';

  final ApiService _apiService;

  Future<void> restoreSession() async {
	final prefs = await SharedPreferences.getInstance();
	final token = prefs.getString(_tokenKey);
	_apiService.setAccessToken(token);
	if (token != null && token.isNotEmpty) {
	  await _syncPermissionPreferencesIfAvailable();
	}
  }

  Future<String> sendOtp({required String phone}) async {
	final response = await _apiService.postJson(
	  '/v1/auth/otp/send',
	  body: {'phoneE164': phone},
	);
	return response['verificationId']?.toString() ?? '';
  }

  Future<AuthResult> verifyOtp({
	required String phone,
	required String verificationId,
	required String otpCode,
  }) async {
	final response = await _apiService.postJson(
	  '/v1/auth/otp/verify',
	  body: {
		'phoneE164': phone,
		'verificationId': verificationId,
		'otpCode': otpCode,
	  },
	);

	return _consumeAuthResponse(response);
  }

  Future<AuthResult> signInWithGoogleToken(String idToken) async {
	final response = await _apiService.postJson(
	  '/v1/auth/verify',
	  body: {'token': idToken},
	);
	return _consumeAuthResponse(response);
  }

  Future<void> logout() async {
	final prefs = await SharedPreferences.getInstance();
	await prefs.remove(_tokenKey);
	_apiService.setAccessToken(null);
  }

  Future<String?> getSavedUserName() async {
	final prefs = await SharedPreferences.getInstance();
	return prefs.getString(_userNameKey);
  }

  Future<UserModel> updateProfile({
	required String name,
	String language = 'English',
	String? photoUrl,
  }) async {
	final response = await _apiService.putJson(
	  '/v1/me/profile',
	  body: {
		'name': name,
		'language': language,
		if (photoUrl != null && photoUrl.isNotEmpty) 'photoUrl': photoUrl,
	  },
	);
	final user = UserModel.fromJson(response['user'] as Map<String, dynamic>? ?? const <String, dynamic>{});
	final prefs = await SharedPreferences.getInstance();
	await prefs.setString(_userNameKey, user.name);
	return user;
  }

  Future<AuthResult> _consumeAuthResponse(Map<String, dynamic> response) async {
	final user = UserModel.fromJson(response['user'] as Map<String, dynamic>? ?? const <String, dynamic>{});
	final accessToken = response['accessToken']?.toString() ?? '';
	final profileCompleted = response['profileCompleted'] == true || user.profileCompleted;

	final prefs = await SharedPreferences.getInstance();
	await prefs.setString(_tokenKey, accessToken);
	await prefs.setString(_userNameKey, user.name);
	_apiService.setAccessToken(accessToken);
	await _syncPermissionPreferencesIfAvailable();

	return AuthResult(
	  user: user,
	  accessToken: accessToken,
	  profileCompleted: profileCompleted,
	);
  }

  Future<void> _syncPermissionPreferencesIfAvailable() async {
	final prefs = await SharedPreferences.getInstance();
	if (!prefs.containsKey(_locationEnabledKey) &&
		!prefs.containsKey(_notificationsEnabledKey) &&
		!prefs.containsKey(_pendingSyncLocationKey) &&
		!prefs.containsKey(_pendingSyncNotificationsKey)) {
	  return;
	}

	final locationEnabled = prefs.getBool(_pendingSyncLocationKey) ??
		prefs.getBool(_locationEnabledKey) ??
		false;
	final notificationsEnabled = prefs.getBool(_pendingSyncNotificationsKey) ??
		prefs.getBool(_notificationsEnabledKey) ??
		false;

	try {
	  await _apiService.putJson(
		'/v1/me/preferences',
		body: {
		  'locationEnabled': locationEnabled,
		  'notificationsEnabled': notificationsEnabled,
		},
	  );
	  await prefs.remove(_pendingSyncLocationKey);
	  await prefs.remove(_pendingSyncNotificationsKey);
	} catch (_) {
	  // Ignore sync failures here; PermissionViewModel will retry on next update.
	}
  }
}

