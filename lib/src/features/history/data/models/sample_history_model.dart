class WaterSampleDetails {
  final int userId;
  final String originalNo;
  final String collectionDate;
  final String collectedTime;
  final String collectorName;
  final String mobileNumber;
  final String email;
  final String specialRequestWithReason;
  final String additionalRelevantInformation;
  final String specificParametersToBeTested;
  final String weatherConditions;
  final int areaId;
  final String areaName;
  final String codeName;
  final String codeId;
  final int enquiryTypeId;
  final String enquiryType;
  final int sourceTypeId;
  final String sourceType;
  final int agencyId;
  final String agencyName;
  final int wardId;
  final String wardName;
  final String residualChlorine;
  final String longitude;
  final String latitude;
  final int statusId;
  final String status;

  WaterSampleDetails({
    required this.userId,
    required this.originalNo,
    required this.collectionDate,
    required this.collectedTime,
    required this.collectorName,
    required this.mobileNumber,
    required this.email,
    required this.specialRequestWithReason,
    required this.additionalRelevantInformation,
    required this.specificParametersToBeTested,
    required this.weatherConditions,
    required this.areaId,
    required this.areaName,
    required this.codeName,
    required this.codeId,
    required this.enquiryTypeId,
    required this.enquiryType,
    required this.sourceTypeId,
    required this.sourceType,
    required this.agencyId,
    required this.agencyName,
    required this.wardId,
    required this.wardName,
    required this.residualChlorine,
    required this.longitude,
    required this.latitude,
    required this.statusId,
    required this.status,
  });

  factory WaterSampleDetails.fromJson(Map<String, dynamic> json) {
    return WaterSampleDetails(
      userId: json['User_Id'] ?? 0,
      originalNo: json['OriginalNo'] ?? '',
      collectionDate: json['CollectionDate'] ?? '',
      collectedTime: json['CollectedTime'] ?? '',
      collectorName: json['CollectorName'] ?? '',
      mobileNumber: json['MobileNumber'] ?? '',
      email: json['Email'] ?? '',
      specialRequestWithReason: json['SpecialRequestWithReason'] ?? '',
      additionalRelevantInformation: json['AdditionalRelevantInformation'] ?? '',
      specificParametersToBeTested: json['SpecificParametersToBeTested'] ?? '',
      weatherConditions: json['WeatherConditions'] ?? '',
      areaId: json['AreaId'] ?? 0,
      areaName: json['AreaName'] ?? '',
      codeName: json['CodeName'] ?? '',
      codeId: json['CodeId']?.toString() ?? '',
      enquiryTypeId: json['EnquiryTypeId'] ?? 0,
      enquiryType: json['EnquiryType'] ?? '',
      sourceTypeId: json['SourceTypeId'] ?? 0,
      sourceType: json['SourceType'] ?? '',
      agencyId: json['AgencyId'] ?? 0,
      agencyName: json['AgencyName'] ?? '',
      wardId: json['WardId'] ?? 0,
      wardName: json['WardName'] ?? '',
      residualChlorine: json['ResidualChlorine']?.toString() ?? '',
      longitude: json['Longitude']?.toString() ?? '',
      latitude: json['Latitude']?.toString() ?? '',
      statusId: json['StatusId'] ?? 0,
      status: json['Status'] ?? '',
    );
  }
}

class DocumentModel {
  final int documentId;
  final String originalNo;
  final String documentName;
  final String docBasePath;
  final String docExtension;
  final String fileName;
  final String? fullPath;
  final String fileUrl;

  DocumentModel({
    required this.documentId,
    required this.originalNo,
    required this.documentName,
    required this.docBasePath,
    required this.docExtension,
    required this.fileName,
    this.fullPath,
    required this.fileUrl,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentId: json['documentId'] ?? 0,
      originalNo: json['original_No'] ?? '',
      documentName: json['documentName'] ?? '',
      docBasePath: json['docBasePath'] ?? '',
      docExtension: json['docExtension'] ?? '',
      fileName: json['fileName'] ?? '',
      fullPath: json['fullPath'],
      fileUrl: json['fileUrl'] ?? '',
    );
  }
}
