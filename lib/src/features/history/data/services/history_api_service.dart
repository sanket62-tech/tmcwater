import 'package:water_collector/src/core/services/api_service.dart';
import 'package:water_collector/src/features/history/data/models/sample_history_model.dart';

class HistoryApiService {
  final ApiService _apiService = ApiService();

  Future<List<WaterSampleDetails>> getWaterSampleDetails(int userId) async {
    try {
      final payload = {
        'UserId': userId,
      };

      print('--- FETCHING HISTORY DATA ---');
      // The user mentioned api/Code/GetCodes but the DTOs suggest WaterSample details.
      // Based on the provided request DO "WaterSampleGetRequestDO", 
      // I'll use the likely endpoint name if not explicitly corrected.
      // However, user said: "end point is api/Code/GetCodes". 
      // I will use what the user explicitly said.
      final response = await _apiService.postEncryptedSession('api/WaterSample/GetWaterSampleDetailsByUserId', payload);
      
      dynamic data;
      if (response is Map) {
        data = response['WaterSampleList'] ?? response['Data'] ?? response['data'] ?? response['Result'] ?? response['result'];
      } else if (response is List) {
        data = response;
      }

      if (data is List) {
        final list = data.map((json) => WaterSampleDetails.fromJson(json)).toList();
        print('Successfully parsed ${list.length} history records');
        return list;
      }
      
      print('Warning: No list data found in response for history');
      return [];
    } catch (e) {
      print('Error fetching history data: $e');
      rethrow;
    }
  }

  Future<List<DocumentModel>> getDocuments(String originalNo, int userId) async {
    try {
      final queryParameters = {
        'originalNo': originalNo,
        'userId': userId,
      };

      print('--- FETCHING DOCUMENTS ---');
      final response = await _apiService.get('api/InsertDoc/GetDocuments', queryParameters: queryParameters);

      if (response != null && response['success'] == true) {
        final data = response['data'];
        if (data != null && data['success'] == true) {
          final docList = data['documentList'] as List?;
          if (docList != null) {
            return docList.map((json) => DocumentModel.fromJson(json)).toList();
          }
        }
      }
      return [];
    } catch (e) {
      print('Error fetching documents: $e');
      return []; // Return empty list on error to avoid breaking UI
    }
  }
}
