import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
	static const _verificationPath = '/api/auth/verify';
	final String mockOtp = '471515';

	final ApiService _apiService;
	final FirebaseAuth _auth = FirebaseAuth.instance;
	String? _pendingMockPhoneNumber;

	// ==============================
	// RESTORE SESSION
	// ==============================
	Future<void> restoreSession() async {
		final prefs = await SharedPreferences.getInstance();
		final token = prefs.getString(_tokenKey);
		_apiService.setAccessToken(token);
	}

	// ==============================
	// SEND OTP (MOCK)
	// ==============================
	Future<String> sendOtp({
		required String phoneNumber,
		void Function()? onAutoRetrievalTimeout,
	}) async {
		await Future.delayed(const Duration(seconds: 1));
		_pendingMockPhoneNumber = phoneNumber;
		onAutoRetrievalTimeout?.call();
		if (kDebugMode) {
			debugPrint('[OTP-MOCK] sendOtp phoneNumber=$phoneNumber');
		}
		return 'mock-verification-$phoneNumber';
	}

	// ==============================
	// VERIFY OTP (MOCK)
	// ==============================
	Future<AuthResult> verifyOtp({
		required String phoneNumber,
		required String otpCode,
	}) async {
		await Future.delayed(const Duration(seconds: 1));
		if (kDebugMode) {
			debugPrint('[OTP-MOCK] verifyOtp phoneNumber=$phoneNumber otpCodeLength=${otpCode.length}');
		}

		if (_pendingMockPhoneNumber == null || _pendingMockPhoneNumber != phoneNumber) {
			throw ApiException('OTP session expired. Request OTP again.');
		}

		if (otpCode.trim() != mockOtp) {
			throw ApiException('Invalid OTP');
		}

		final user = UserModel(
			id: 'mock-${phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')}',
			name: 'Mock Rider',
			phone: phoneNumber,
			email: null,
			profileCompleted: true,
		);

		const accessToken = 'mock-access-token';
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(_tokenKey, accessToken);
		await prefs.setString(_userNameKey, user.name);
		_apiService.setAccessToken(accessToken);

		return AuthResult(
			user: user,
			accessToken: accessToken,
			profileCompleted: true,
		);
	}

	Future<UserModel> completeProfile({
		required String name,
		required String language,
	}) async {
		final response = await _apiService.putJson(
			'/v1/me/profile',
			body: {
				'name': name,
				'language': language,
			},
		);

		final rawUser = response['user'];
		if (rawUser is! Map<String, dynamic>) {
			throw ApiException('Invalid profile response from server.');
		}

		final user = UserModel.fromJson(rawUser);
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(_userNameKey, user.name);
		return user;
	}

	Future<AuthResult> signInWithGoogle() async {
		try {
			final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

			if (googleUser == null) {
				throw ApiException('Google sign-in cancelled');
			}

			final GoogleSignInAuthentication googleAuth =
			await googleUser.authentication;

			final credential = GoogleAuthProvider.credential(
				accessToken: googleAuth.accessToken,
				idToken: googleAuth.idToken,
			);

			final userCredential =
			await _auth.signInWithCredential(credential);

			final user = userCredential.user;

			if (user == null) {
				throw ApiException('Google sign-in failed');
			}

			final idToken = await user.getIdToken(true);

			if (idToken == null || idToken.isEmpty) {
				throw ApiException('Unable to get Firebase token');
			}

			return _verifyFirebaseToken(idToken);
		} on ApiException {
			rethrow;
		} on FirebaseAuthException catch (e) {
			throw ApiException(e.message ?? 'Google sign-in failed');
		} catch (e) {
			throw ApiException('Google sign-in failed. Please try again.');
		}
	}

	Future<AuthResult> _verifyFirebaseToken(String idToken) async {
		Map<String, dynamic> response;
		try {
			response = await _apiService.postJson(
				_verificationPath,
				body: {'token': idToken},
				extraHeaders: {'Authorization': 'Bearer $idToken'},
			);
		} on ApiException catch (e) {
			if (e.statusCode == 501) {
				throw ApiException(
					'Backend Firebase Admin is not configured. Set FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, and FIREBASE_PRIVATE_KEY in backend/.env, then restart backend.',
				);
			}
			throw ApiException(e.message);
		}

		final accessToken = response['accessToken']?.toString();
		final rawUser = response['user'];
		if (accessToken == null || accessToken.isEmpty) {
			throw ApiException('Server did not return access token.');
		}
		if (rawUser is! Map<String, dynamic>) {
			throw ApiException('Invalid user payload from server.');
		}

		final user = UserModel.fromJson(rawUser);
		final profileCompleted = response['profileCompleted'] == true || user.profileCompleted;

		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(_tokenKey, accessToken);
		await prefs.setString(_userNameKey, user.name);
		_apiService.setAccessToken(accessToken);

		return AuthResult(
			user: user,
			accessToken: accessToken,
			profileCompleted: profileCompleted,
		);
	}

	// ==============================
	// LOGOUT
	// ==============================
	Future<void> logout() async {
		await _auth.signOut();
		final prefs = await SharedPreferences.getInstance();
		await prefs.remove(_tokenKey);
		_apiService.setAccessToken(null);
	}

	// ==============================
	// GET USER NAME
	// ==============================
	Future<String?> getSavedUserName() async {
		final prefs = await SharedPreferences.getInstance();
		return prefs.getString(_userNameKey);
	}
}