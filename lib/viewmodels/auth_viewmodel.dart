import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authService);

  final AuthService _authService;

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;
  String? _verificationId;

  Future<void> bootstrap() async {
	await _authService.restoreSession();
	notifyListeners();
  }

  Future<void> sendOtp(String phoneNumber) async {
	_startLoading();
	try {
	  _verificationId = await _authService.sendOtp(phone: phoneNumber);
	  errorMessage = null;
	} catch (e) {
	  errorMessage = e.toString();
	} finally {
	  _stopLoading();
	}
  }

  Future<bool> verifyOtp({required String phoneNumber, required String otpCode}) async {
	_startLoading();
	try {
	  if (_verificationId == null || _verificationId!.isEmpty) {
		throw Exception('OTP session expired. Please request OTP again.');
	  }
	  final result = await _authService.verifyOtp(
		phone: phoneNumber,
		verificationId: _verificationId!,
		otpCode: otpCode,
	  );
	  currentUser = result.user;
	  errorMessage = null;
	  return result.profileCompleted;
	} catch (e) {
	  errorMessage = e.toString();
	  return false;
	} finally {
	  _stopLoading();
	}
  }

  Future<bool> signInWithGoogle() async {
	_startLoading();
	try {
	  // Temporary dev token. Replace with Firebase Google sign-in token once keys are configured.
	  const devToken = 'dev-google-token';
	  final result = await _authService.signInWithGoogleToken(devToken);
	  currentUser = result.user;
	  errorMessage = null;
	  return result.profileCompleted;
	} catch (e) {
	  errorMessage = e.toString();
	  return false;
	} finally {
	  _stopLoading();
	}
  }

  Future<bool> completeProfile({required String name, required String language}) async {
	_startLoading();
	try {
	  final user = await _authService.updateProfile(name: name, language: language);
	  currentUser = user;
	  errorMessage = null;
	  return true;
	} catch (e) {
	  errorMessage = e.toString();
	  return false;
	} finally {
	  _stopLoading();
	}
  }

  void clearError() {
	errorMessage = null;
	notifyListeners();
  }

  void _startLoading() {
	isLoading = true;
	notifyListeners();
  }

  void _stopLoading() {
	isLoading = false;
	notifyListeners();
  }
}

