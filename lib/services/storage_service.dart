import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';

  // Save authentication token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Retrieve authentication token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Check whether user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Delete authentication token during logout
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
