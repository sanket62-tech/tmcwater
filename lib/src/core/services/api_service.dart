import 'dart:convert';
import 'dart:typed_data';
import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:water_collector/src/core/services/encryption_service.dart';
import 'package:water_collector/src/core/services/storage_service.dart';

class ApiService {
  static const String baseUrl = 'http://103.118.17.144:8090/';

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptor for Bearer Token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService().getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          print('--- AUTH TOKEN ATTACHED ---');
        }
        return handler.next(options);
      },
    ));
  }

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  /// POST request with encrypted payload and decrypted response
  Future<dynamic> postEncrypted(String path, dynamic data) async {
    try {
      print('--- API REQUEST (POST: $path) ---');
      print('Original Request Data: $data');

      // 1. Encrypt the request data
      final encryptedPayload = await EncryptionService.encrypt(data: data);
      print('Encrypted Request Payload: $encryptedPayload');

      // 2. Send the POST request
      final response = await _dio.post(path, data: encryptedPayload);

      return _processResponse(response, path);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// GET request with decrypted response
  Future<dynamic> getEncrypted(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      print('--- API REQUEST (GET: $path) ---');
      if (queryParameters != null) print('Query Parameters: $queryParameters');

      // 1. Send the GET request
      final response = await _dio.get(path, queryParameters: queryParameters);

      return _processResponse(response, path);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// POST request where the server responds with data encrypted using the SAME AES Key/IV sent in the request
  Future<dynamic> postEncryptedSession(String path, dynamic data) async {
    try {
      print('--- API SESSION REQUEST (POST: $path) ---');
      print('Original Request Data: $data');

      // 1. Encrypt with Session (saves the key/iv used)
      final session = await EncryptionService.encryptWithSession(data: data);
      print('Encrypted Request Payload: ${session.payloadForServer}');

      // 2. Send the POST request
      final response = await _dio.post(path, data: session.payloadForServer);
      print('--- API SESSION RESPONSE ($path) ---');
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;
        print('Encrypted Response Data: $responseData');

        // 3. Extract the encrypted data from the response
        // Handle both PascalCase and camelCase keys from the log
        String? encryptedData;
        String? ivStr;
        String? encryptedAesKey;

        if (responseData is Map) {
          encryptedData = responseData['EncryptedData'] ?? responseData['encryptedData'];
          ivStr = responseData['IV'] ?? responseData['iv'];
          encryptedAesKey = responseData['EncryptedAESKey'] ?? responseData['encryptedAESKey'];
        } else if (responseData is String) {
          encryptedData = responseData;
        }

        if (encryptedData == null) {
          print('Error: Response format not recognized for session decryption. Response keys: ${responseData is Map ? responseData.keys.toList() : 'Not a map'}');
          return responseData;
        }

        // 4. Determine which AES Key and IV to use
        Uint8List aesKeyToUse = session.aesKeyBytes;
        Uint8List ivToUse = session.ivBytes;

        if (encryptedAesKey != null && encryptedAesKey.isNotEmpty) {
          print('Server provided a new EncryptedAESKey. Decrypting with RSA...');
          try {
            final encryptedAESKeyBytes = EncryptionService.base64ToBytes(encryptedAesKey);
            final privateKey = CryptoUtils.rsaPrivateKeyFromPem(EncryptionService.rsaPrivateKeyPem);
            aesKeyToUse = EncryptionService.rsaOaepDecrypt(encryptedAESKeyBytes, privateKey);
            print('New AES Key decrypted successfully (Length: ${aesKeyToUse.length})');
          } catch (e) {
            print('Warning: Failed to decrypt server provided AES key ($e). Falling back to session key.');
          }
        }

        if (ivStr != null && ivStr.isNotEmpty) {
          ivToUse = EncryptionService.base64ToBytes(ivStr);
        }

        // 5. Decrypt the data
        print('Attempting AES-CBC Decryption...');
        final decryptedBytes = EncryptionService.aesCbcDecrypt(
          EncryptionService.base64ToBytes(encryptedData),
          aesKeyToUse,
          ivToUse,
        );

        final decryptedString = utf8.decode(decryptedBytes);
        print('Decrypted Response String: $decryptedString');

        // Return as JSON if possible
        try {
          final trimmed = decryptedString.trim();
          final decoded = (trimmed.startsWith('{') || trimmed.startsWith('['))
              ? json.decode(trimmed)
              : trimmed;
          if (decoded is! String) print('Decrypted Response JSON: $decoded');
          return decoded;
        } catch (_) {
          return decryptedString;
        }
      }
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<dynamic> _processResponse(Response response, String path) async {
    print('--- API RESPONSE ($path) ---');
    print('Response Status Code: ${response.statusCode}');

    // Check if response is successful and contains encrypted data
    if (response.statusCode == 200 && response.data != null) {
      final responseData = response.data;
      print('Encrypted Response Data: $responseData');
      
      // Ensure the response has the required encrypted fields
      if (responseData is Map &&
          responseData.containsKey('EncryptedAESKey') &&
          responseData.containsKey('EncryptedData') &&
          responseData.containsKey('IV')) {
        
        // Decrypt the response data
        final decryptedString = await EncryptionService.decrypt(
          encryptedAESKeyBase64: responseData['EncryptedAESKey'],
          encryptedDataBase64: responseData['EncryptedData'],
          ivBase64: responseData['IV'],
        );
        print('Decrypted Response String: $decryptedString');

        // Return as JSON if possible, otherwise as string
        try {
          final trimmed = decryptedString.trim();
          final decoded = (trimmed.startsWith('{') || trimmed.startsWith('['))
              ? json.decode(trimmed)
              : trimmed;
          if (decoded is! String) print('Decrypted Response JSON: $decoded');
          return decoded;
        } catch (_) {
          return decryptedString;
        }
      }
      return responseData;
    }
    print('Non-200 or Empty Response Body');
    return response.data;
  }

  /// Standard GET request without encryption
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      print('--- API REQUEST (GET: $path) ---');
      if (queryParameters != null) print('Query Parameters: $queryParameters');

      final response = await _dio.get(path, queryParameters: queryParameters);
      print('--- API RESPONSE ($path) ---');
      print('Response Status Code: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return 'Connection timeout';
    if (e.type == DioExceptionType.receiveTimeout) return 'Server response timeout';
    if (e.response != null) {
      return 'Server error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
    }
    return 'Network error: ${e.message}';
  }

  /// Simple Multipart POST request without encryption
  Future<dynamic> postMultipart(String path, FormData formData) async {
    try {
      print('--- API MULTIPART REQUEST (POST: $path) ---');
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      print('--- API MULTIPART RESPONSE ($path) ---');
      print('Response Status Code: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }
}
