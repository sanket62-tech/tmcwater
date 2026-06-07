class WaterSampleInsertRequest {
  final int userId;
  final String collectedDate;
  final String collectedTime;
  final String collectorName;
  final String mobileNumber;
  final String email;
  final int waterSourceType;
  final int agency;
  final int ward;
  final int type;
  final int area;
  final int codeName;
  final double chlorinoMeterTest;
  final String specialRequestWithReason;
  final String additionalRelevantInformation;
  final String specificParametersToBeTested;
  final String weatherConditions;
  final double latitude;
  final double longitude;
  final int statusId;
  final int createdBy;
  final int isFromMobile;

  WaterSampleInsertRequest({
    required this.userId,
    required this.collectedDate,
    required this.collectedTime,
    required this.collectorName,
    required this.mobileNumber,
    required this.email,
    required this.waterSourceType,
    required this.agency,
    required this.ward,
    required this.type,
    required this.area,
    required this.codeName,
    required this.chlorinoMeterTest,
    required this.specialRequestWithReason,
    required this.additionalRelevantInformation,
    required this.specificParametersToBeTested,
    required this.weatherConditions,
    required this.latitude,
    required this.longitude,
    required this.statusId,
    required this.createdBy,
    required this.isFromMobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'CollectedDate': collectedDate,
      'CollectedTime': collectedTime,
      'CollectorName': collectorName,
      'MobileNumber': mobileNumber,
      'Email': email,
      'WaterSourceType': waterSourceType,
      'Agency': agency,
      'Ward': ward,
      'Type': type,
      'Area': area,
      'CodeName': codeName,
      'ChlorinoMeterTest': chlorinoMeterTest,
      'SpecialRequestWithReason': specialRequestWithReason,
      'AdditionalRelevantInformation': additionalRelevantInformation,
      'SpecificParametersToBeTested': specificParametersToBeTested,
      'WeatherConditions': weatherConditions,
      'Latitude': latitude,
      'Longitude': longitude,
      'StatusId': statusId,
      'CreatedBy': createdBy,
      'IsFromMobile': isFromMobile,
    };
  }
}

class WaterSampleResponse {
  final bool success;
  final int statusCode;
  final String message;
  final int? id;
  final String? originalNo;
  final int? statusId;

  WaterSampleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.id,
    this.originalNo,
    this.statusId,
  });

  factory WaterSampleResponse.fromJson(Map<String, dynamic> json) {
    return WaterSampleResponse(
      success: json['Success'] ?? json['success'] ?? false,
      statusCode: json['StatusCode'] ?? json['statusCode'] ?? 0,
      message: json['Message'] ?? json['message'] ?? '',
      id: json['ID'] ?? json['id'],
      originalNo: json['Original_No'] ?? json['original_No'],
      statusId: json['Status_ID'] ?? json['status_ID'],
    );
  }
}
