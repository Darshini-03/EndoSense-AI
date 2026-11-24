import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  // USER LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post('/login', {
      'email': email,
      'password': password,
    });

    // Save token returned by backend.
    final token = response['token'] ?? response['access_token'];

    if (token is String && token.isNotEmpty) {
      await StorageService.saveToken(token);
    }

    return response;
  }

  // USER REGISTRATION
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String gender,
    required String password,
  }) async {
    return await ApiService.post('/register', {
      'name': name,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'password': password,
    });
  }

  // FORGOT PASSWORD
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    return await ApiService.post('/forgot-password', {'email': email});
  }

  // CHECK LOGIN SESSION
  static Future<bool> isLoggedIn() async {
    return await StorageService.isLoggedIn();
  }

  // LOGOUT
  static Future<void> logout() async {
    await StorageService.deleteToken();
  }
}
