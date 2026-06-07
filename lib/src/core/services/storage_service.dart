import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:water_collector/src/features/auth/data/models/login_model.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  
  static const String _keyToken = 'auth_token';
  static const String _keyUserData = 'user_data';
  static const String _keyLanguage = 'language_code';

  // Singleton
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<void> saveLanguageCode(String code) async {
    await _storage.write(key: _keyLanguage, value: code);
  }

  Future<String?> getLanguageCode() async {
    return await _storage.read(key: _keyLanguage);
  }

  Future<void> saveLoginResponse(LoginResponse response) async {
    if (response.token != null) {
      await _storage.write(key: _keyToken, value: response.token);
    }
    await _storage.write(
      key: _keyUserData, 
      value: jsonEncode(response.toJson()),
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<LoginResponse?> getUserData() async {
    final data = await _storage.read(key: _keyUserData);
    if (data != null) {
      return LoginResponse.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
