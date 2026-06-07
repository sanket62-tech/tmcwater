import 'package:water_collector/src/core/services/api_service.dart';
import 'package:water_collector/src/features/auth/data/models/login_model.dart';

class AuthApiService {
  final ApiService _apiService = ApiService();

  Future<LoginResponse> login(String username, String password) async {
    try {
      final payload = {
        'Username': username,
        'Password': password,
      };

      // Using api/Auth/Login endpoint with session-based encryption
      final response = await _apiService.postEncryptedSession('api/Auth/Login', payload);
      
      if (response is Map<String, dynamic>) {
        return LoginResponse.fromJson(response);
      } else {
        throw 'Unexpected response format from server';
      }
    } catch (e) {
      rethrow;
    }
  }
}
