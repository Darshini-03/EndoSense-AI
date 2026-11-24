import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator address for your local Flask backend.
  static const String baseUrl = 'http://10.0.2.2:5000';

  static const Duration timeoutDuration = Duration(seconds: 20);

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Unable to connect to server: $e');
    }
  }

  // GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final requestHeaders = {
        ...headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: requestHeaders)
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Unable to connect to server: $e');
    }
  }

  // Response handling
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Invalid response received from server');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected server response');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw Exception(
      decoded['message'] ??
          decoded['error'] ??
          'Server error: ${response.statusCode}',
    );
  }
}
