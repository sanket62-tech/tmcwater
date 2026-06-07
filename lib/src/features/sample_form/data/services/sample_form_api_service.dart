import 'package:dio/dio.dart';
import 'package:water_collector/src/core/services/api_service.dart';
import 'package:water_collector/src/features/sample_form/data/models/dropdown_model.dart';
import 'package:water_collector/src/features/sample_form/data/models/water_sample_model.dart';

class SampleFormApiService {
  final ApiService _apiService = ApiService();

  Future<dynamic> uploadDocuments({
    required List<String> filePaths,
    required String originalNo,
    required int userId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'originalNo': originalNo,
        'userId': userId,
      });

      for (var path in filePaths) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(path),
        ));
      }

      return await _apiService.postMultipart(
        'api/InsertDoc/UploadDocuments',
        formData,
      );
    } catch (e) {
      print('Error uploading documents: $e');
      rethrow;
    }
  }

  Future<WaterSampleResponse> insertWaterSampleDetails(WaterSampleInsertRequest request) async {
    try {
      final response = await _apiService.postEncryptedSession(
        'api/WaterSample/InsertWaterSampleDetails',
        request.toJson(),
      );
      if (response is Map<String, dynamic>) {
        return WaterSampleResponse.fromJson(response);
      } else {
        throw 'Unexpected response format';
      }
    } catch (e) {
      print('Error inserting water sample: $e');
      rethrow;
    }
  }

  Future<List<DropdownModel>> getSourceTypes() async {
    return _getDropdownData('api/DDL/GetSourceTypes');
  }

  Future<List<DropdownModel>> getAgencies() async {
    return _getDropdownData('api/DDL/GetAgencies');
  }

  Future<List<DropdownModel>> getWards() async {
    return _getDropdownData('api/DDL/GetWards');
  }

  Future<List<DropdownModel>> getEnquiryTypes() async {
    return _getDropdownData('api/DDL/GetEnquiryTypes');
  }

  Future<List<DropdownModel>> getAreas() async {
    return _getDropdownData('api/DDL/GetAreas');
  }

  Future<List<DropdownModel>> getSourceCodes(int wardId) async {
    try {
      final payload = {
        'WardId': wardId,
      };

      print('--- FETCHING CODES DATA: api/Code/GetCodes ---');
      print('Payload: $payload');
      final response = await _apiService.postEncryptedSession('api/Code/GetCodes', payload);
      
      dynamic data;
      if (response is Map) {
        data = response['CodeList'] ?? response['Data'] ?? response['data'] ?? response['Result'] ?? response['result'];
      } else if (response is List) {
        data = response;
      }

      if (data is List) {
        final list = data.map((json) => DropdownModel.fromJson(json)).toList();
        print('Successfully parsed ${list.length} items from api/Code/GetCodes');
        return list;
      }
      
      print('Warning: No list data found in response for api/Code/GetCodes');
      return [];
    } catch (e) {
      print('Error fetching source codes: $e');
      rethrow;
    }
  }

  Future<List<DropdownModel>> _getDropdownData(String endpoint, {Map<String, dynamic>? payload}) async {
    try {
      final defaultPayload = {
        'CountryId': 0,
        'countryId': 0,
        'StateId': 0,
        'stateId': 0,
        'DistrictId': 0,
        'districtId': 0,
        'RegionId': 0,
        'regionId': 0,
      };

      final requestPayload = {
        ...defaultPayload,
        ...?payload,
      };

      print('--- FETCHING DDL DATA: $endpoint ---');
      print('Payload: $requestPayload');
      final response = await _apiService.postEncryptedSession(endpoint, requestPayload);
      
      dynamic data;
      if (response is Map) {
        data = response['Data'] ?? response['data'] ?? response['Result'] ?? response['result'];
      } else if (response is List) {
        data = response;
      }

      if (data is List) {
        final list = data.map((json) => DropdownModel.fromJson(json)).toList();
        print('Successfully parsed ${list.length} items from $endpoint');
        return list;
      }
      
      print('Warning: No list data found in response for $endpoint');
      return [];
    } catch (e) {
      print('Error fetching dropdown data for $endpoint: $e');
      rethrow;
    }
  }
}
