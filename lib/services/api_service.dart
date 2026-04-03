import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
	  : _client = client ?? http.Client(),
		baseUrl = baseUrl ?? const String.fromEnvironment('JANRIDE_API_BASE', defaultValue: 'http://10.0.2.2:8080');

  final http.Client _client;
  final String baseUrl;

  String? _accessToken;

  void setAccessToken(String? token) {
	_accessToken = token;
  }

  Future<Map<String, dynamic>> getJson(String path, {Map<String, String>? query}) async {
	final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
	final response = await _client.get(uri, headers: _headers());
	return _decode(response);
  }

  Future<Map<String, dynamic>> postJson(String path, {Map<String, dynamic>? body}) async {
	final uri = Uri.parse('$baseUrl$path');
	final response = await _client.post(
	  uri,
	  headers: _headers(),
	  body: jsonEncode(body ?? const <String, dynamic>{}),
	);
	return _decode(response);
  }

  Future<Map<String, dynamic>> putJson(String path, {Map<String, dynamic>? body}) async {
	final uri = Uri.parse('$baseUrl$path');
	final response = await _client.put(
	  uri,
	  headers: _headers(),
	  body: jsonEncode(body ?? const <String, dynamic>{}),
	);
	return _decode(response);
  }

  Map<String, String> _headers() {
	return {
	  'Content-Type': 'application/json',
	  if (_accessToken != null && _accessToken!.isNotEmpty) 'Authorization': 'Bearer $_accessToken',
	};
  }

  Map<String, dynamic> _decode(http.Response response) {
	final body = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
	if (response.statusCode >= 200 && response.statusCode < 300) {
	  return body;
	}
	throw ApiException(
	  body['message']?.toString() ?? 'Request failed with status ${response.statusCode}',
	  statusCode: response.statusCode,
	);
  }
}

