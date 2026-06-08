// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get profileSettings => 'प्रोफाइल सेटिंग';

  @override
  String get notifications => 'सूचना';

  @override
  String get privacySecurity => 'गोपनीयता आणि सुरक्षा';

  @override
  String get language => 'भाषा';

  @override
  String get helpSupport => 'मदत आणि समर्थन';

  @override
  String get aboutApp => 'अॅपबद्दल';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get waterCollector => 'पाणी संकलक';

  @override
  String get profileDetails => 'प्रोफाइल तपशील';

  @override
  String get fullName => 'पूर्ण नाव';

  @override
  String get email => 'ईमेल';

  @override
  String get username => 'वापरकर्तानाव';

  @override
  String get role => 'भूमिका';

  @override
  String get close => 'बंद करा';

  @override
  String get sampleFormAppBarTitle => 'जल चाचणी';

  @override
  String get sampleFormAppBarSubtitle => 'नमुना संकलन फॉर्म';

  @override
  String get help => 'मदत';

  @override
  String get collectorInformation => 'संकलक माहिती';

  @override
  String get locationDetails => 'स्थान तपशील';

  @override
  String get sampleSourceClassification => 'नमुना स्रोत आणि वर्गीकरण';

  @override
  String get additionalDetails => 'अतिरिक्त तपशील';

  @override
  String get stepInfo => 'माहिती';

  @override
  String get stepLocation => 'स्थान';

  @override
  String get stepSource => 'स्रोत';

  @override
  String get stepDetails => 'तपशील';

  @override
  String get collectedDateLabel => 'संकलन तारीख *';

  @override
  String get collectedDateHint => 'DD / MM / YYYY';

  @override
  String get collectedTimeLabel => 'संकलन वेळ *';

  @override
  String get collectedTimeHint => 'HH : MM';

  @override
  String get collectorNameLabel => 'संकलकाचे नाव *';

  @override
  String get collectorNameHint => 'पूर्ण नाव प्रविष्ट करा';

  @override
  String get mobileNumberLabel => 'मोबाईल क्रमांक *';

  @override
  String get mobileNumberHint => '१०-अंकी मोबाईल क्रमांक';

  @override
  String get emailAddressLabel => 'ईमेल पत्ता';

  @override
  String get emailAddressHint => 'collector@tmc.gov.in (ऐच्छिक)';

  @override
  String get weatherConditionsLabel => 'हवामान स्थिती *';

  @override
  String get selectWeatherHint => 'हवामान निवडा';

  @override
  String get geoTaggingLabel => 'जिओ-टॅगिंग *';

  @override
  String get tapToCaptureLocation => 'स्थान कॅप्चर करण्यासाठी टॅप करा';

  @override
  String get recapture => 'पुन्हा कॅप्चर करा';

  @override
  String get capture => 'कॅप्चर करा';

  @override
  String get capturePhotosLabel => 'फोटो कॅप्चर करा';

  @override
  String get addPhoto => 'फोटो जोडा';

  @override
  String get waterSourceTypeLabel => 'पाणी / स्रोत प्रकार';

  @override
  String get agencyLabel => 'संस्था';

  @override
  String get wardLabel => 'प्रभाग';

  @override
  String get typeLabel => 'प्रकार';

  @override
  String get areaLabel => 'क्षेत्र';

  @override
  String get codeNameLabel => 'कोड / नाव';

  @override
  String get codeNameHelperText =>
      'कोड / नाव पर्याय निवडलेल्या प्रभागावर अवलंबून असतात.';

  @override
  String get selectPrefix => 'निवडा';

  @override
  String get chlorineMeterTestLabel => 'क्लोरिनो मीटर चाचणी *';

  @override
  String get chlorineHint => '0.00';

  @override
  String get ppmUnit => 'ppm';

  @override
  String get specialRequestLabel => 'कारणासह विशेष विनंती';

  @override
  String get specialRequestHint =>
      'कोणतीही विशेष चाचणी विनंती आणि कारण यांचे वर्णन करा…';

  @override
  String get additionalInfoLabel => 'कोणतीही अतिरिक्त संबंधित माहिती';

  @override
  String get additionalInfoHint => 'उदा. अलीकडील तक्रारी, दृश्यमान दूषितता…';

  @override
  String get specificParamsLabel => 'चाचणी करावयाचे विशिष्ट मापदंड';

  @override
  String get specificParamsHint => 'उदा. pH, गढूळपणा, E.coli, TDS, कठीणपणा…';

  @override
  String get requiredField => 'आवश्यक';

  @override
  String get enterValidMobileNumber => 'वैध १०-अंकी क्रमांक प्रविष्ट करा';

  @override
  String get invalidEmail => 'अवैध ईमेल';

  @override
  String get pleaseCaptureLocation => 'कृपया स्थान कॅप्चर करा';

  @override
  String errorLoadingFormData(String error) {
    return 'फॉर्म डेटा लोड करताना त्रुटी: $error';
  }

  @override
  String failedToLoadSourceCodes(String error) {
    return 'स्रोत कोड लोड करण्यात अयशस्वी: $error';
  }

  @override
  String get locationServicesDisabled => 'स्थान सेवा अक्षम आहेत.';

  @override
  String get locationPermissionDenied => 'स्थान परवानग्या नाकारल्या आहेत';

  @override
  String get locationPermissionPermanentlyDenied =>
      'स्थान परवानग्या कायमस्वरूपी नाकारल्या आहेत, आम्ही परवानगी मागू शकत नाही.';

  @override
  String errorFetchingLocation(String error) {
    return 'स्थान मिळवताना त्रुटी: $error';
  }

  @override
  String get captureFromCamera => 'कॅमेऱ्याने कॅप्चर करा';

  @override
  String get chooseFromGalleryMultiple => 'गॅलरीमधून निवडा (एकाधिक)';

  @override
  String get formSavedSomeImagesFailed =>
      'फॉर्म जतन झाला, परंतु काही प्रतिमा अपलोड करण्यात अयशस्वी झाल्या.';

  @override
  String errorWithMessage(String error) {
    return 'त्रुटी: $error';
  }

  @override
  String get pleaseFillAllRequiredFields => 'कृपया सर्व आवश्यक फील्ड भरा.';

  @override
  String get success => 'यशस्वी';

  @override
  String get originalNoLabel => 'मूळ क्रमांक: ';

  @override
  String get notAvailable => 'लागू नाही';

  @override
  String get ok => 'ठीक आहे';

  @override
  String get submitSampleForm => 'नमुना फॉर्म सबमिट करा';

  @override
  String get submitting => 'सबमिट करत आहे…';

  @override
  String get historyAppBarSubtitle => 'नमुना इतिहास';

  @override
  String get refresh => 'रिफ्रेश करा';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String get searchHistoryHint => 'मूळ क्रमांक, प्रभाग द्वारे शोधा...';

  @override
  String get recentSubmissions => 'अलीकडील सबमिशन';

  @override
  String recordsCount(int count) {
    return '$count नोंदी';
  }

  @override
  String get columnOriginalNo => 'मूळ क्रमांक';

  @override
  String get columnWard => 'प्रभाग';

  @override
  String get columnType => 'प्रकार';

  @override
  String get columnDate => 'तारीख';

  @override
  String get columnDetails => 'तपशील';

  @override
  String get sampleDetails => 'नमुना तपशील';

  @override
  String get generalInfo => 'सामान्य माहिती';

  @override
  String get collectorInfo => 'संकलक माहिती';

  @override
  String get locationSource => 'स्थान आणि स्रोत';

  @override
  String get testingInfo => 'चाचणी माहिती';

  @override
  String get uploadedDocuments => 'अपलोड केलेली कागदपत्रे';

  @override
  String get noDocumentsFound => 'कोणतीही कागदपत्रे आढळली नाहीत.';

  @override
  String get couldNotOpenDocument => 'दस्तऐवज दुवा उघडता आला नाही.';

  @override
  String get detailOriginalNo => 'मूळ क्रमांक';

  @override
  String get detailStatus => 'स्थिती';

  @override
  String get detailDate => 'तारीख';

  @override
  String get detailTime => 'वेळ';

  @override
  String get detailName => 'नाव';

  @override
  String get detailMobile => 'मोबाईल';

  @override
  String get detailEmail => 'ईमेल';

  @override
  String get detailWard => 'प्रभाग';

  @override
  String get detailArea => 'क्षेत्र';

  @override
  String get detailSourceType => 'स्रोत प्रकार';

  @override
  String get detailAgency => 'संस्था';

  @override
  String get detailCodeId => 'कोड आयडी';

  @override
  String get detailCodeName => 'कोड नाव';

  @override
  String get detailWeather => 'हवामान';

  @override
  String get detailLatLong => 'अक्षांश/रेखांश';

  @override
  String get detailResidualChlorine => 'अवशिष्ट क्लोरीन';

  @override
  String get detailEnquiryType => 'चौकशी प्रकार';

  @override
  String get detailSpecialRequest => 'विशेष विनंती';

  @override
  String get detailAdditionalInfo => 'अतिरिक्त माहिती';

  @override
  String get detailSpecificParams => 'विशिष्ट मापदंड';

  @override
  String pageOfLabel(int current, int total) {
    return 'पृष्ठ $current पैकी $total';
  }

  @override
  String get noRecordsFound => 'कोणत्याही नोंदी आढळल्या नाहीत';

  @override
  String noResultsFor(String query) {
    return '\"$query\" साठी कोणतेही परिणाम नाहीत';
  }

  @override
  String get clearSearch => 'शोध साफ करा';
}
