import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
	AuthViewModel(this._authService);

	final AuthService _authService;

	bool isLoading = false;
	String? errorMessage;
	String? _lastRequestedPhone;
	UserModel? currentUser;
	bool profileCompleted = false;
	bool otpAutoRetrievalTimedOut = false;

	String? get lastRequestedPhone => _lastRequestedPhone;

	// ================= LOADING =================
	void _startLoading() {
		isLoading = true;
		notifyListeners();
	}

	void _stopLoading() {
		isLoading = false;
		notifyListeners();
	}

	void clearError() {
		errorMessage = null;
		notifyListeners();
	}

	// ================= SEND OTP =================
	Future<void> sendOtp(String phoneNumber) async {
		_startLoading();
		try {
			_lastRequestedPhone = phoneNumber;
			otpAutoRetrievalTimedOut = false;
			await _authService.sendOtp(
				phoneNumber: phoneNumber,
				onAutoRetrievalTimeout: () {
					otpAutoRetrievalTimedOut = true;
					notifyListeners();
				},
			);
			errorMessage = null;
		} catch (e) {
			errorMessage = e.toString();
		} finally {
			_stopLoading();
		}
	}

	Future<void> resendOtp() async {
		if (_lastRequestedPhone == null || _lastRequestedPhone!.isEmpty) {
			errorMessage = 'Phone number missing. Go back and request OTP again.';
			notifyListeners();
			return;
		}
		await sendOtp(_lastRequestedPhone!);
	}

	// ================= VERIFY OTP =================
	Future<bool> verifyOtp(String otpCode) async {
		_startLoading();
		try {
			if (_lastRequestedPhone == null || _lastRequestedPhone!.isEmpty) {
				throw Exception('OTP session expired. Request again.');
			}

			final result = await _authService.verifyOtp(
				phoneNumber: _lastRequestedPhone!,
				otpCode: otpCode,
			);

			currentUser = result.user;
			profileCompleted = result.profileCompleted;
			otpAutoRetrievalTimedOut = false;
			errorMessage = null;
			return true;
		} catch (e) {
			errorMessage = e.toString();
			return false;
		} finally {
			_stopLoading();
		}
	}

	Future<bool> completeProfile({
		required String name,
		required String language,
	}) async {
		_startLoading();
		try {
			final user = await _authService.completeProfile(
				name: name,
				language: language,
			);
			currentUser = user;
			profileCompleted = user.profileCompleted;
			errorMessage = null;
			return true;
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
			final result = await _authService.signInWithGoogle();
			currentUser = result.user;
			profileCompleted = result.profileCompleted;
			errorMessage = null;
			return result.profileCompleted;
		} catch (e) {
			errorMessage = e.toString();
			return false;
		} finally {
			_stopLoading();
		}
	}
}