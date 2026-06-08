// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get language => 'Language';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get aboutApp => 'About App';

  @override
  String get logout => 'Logout';

  @override
  String get waterCollector => 'Water Collector';

  @override
  String get profileDetails => 'Profile Details';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get username => 'Username';

  @override
  String get role => 'Role';

  @override
  String get close => 'Close';

  @override
  String get sampleFormAppBarTitle => 'Water Testing';

  @override
  String get sampleFormAppBarSubtitle => 'Sample Collection Form';

  @override
  String get help => 'Help';

  @override
  String get collectorInformation => 'Collector Information';

  @override
  String get locationDetails => 'Location Details';

  @override
  String get sampleSourceClassification => 'Sample Source & Classification';

  @override
  String get additionalDetails => 'Additional Details';

  @override
  String get stepInfo => 'Info';

  @override
  String get stepLocation => 'Location';

  @override
  String get stepSource => 'Source';

  @override
  String get stepDetails => 'Details';

  @override
  String get collectedDateLabel => 'Collected Date *';

  @override
  String get collectedDateHint => 'DD / MM / YYYY';

  @override
  String get collectedTimeLabel => 'Collected Time *';

  @override
  String get collectedTimeHint => 'HH : MM';

  @override
  String get collectorNameLabel => 'Collector Name *';

  @override
  String get collectorNameHint => 'Enter full name';

  @override
  String get mobileNumberLabel => 'Mobile Number *';

  @override
  String get mobileNumberHint => '10-digit mobile number';

  @override
  String get emailAddressLabel => 'Email Address';

  @override
  String get emailAddressHint => 'collector@tmc.gov.in (optional)';

  @override
  String get weatherConditionsLabel => 'Weather Conditions *';

  @override
  String get selectWeatherHint => 'Select weather';

  @override
  String get geoTaggingLabel => 'Geo-tagging *';

  @override
  String get tapToCaptureLocation => 'Tap to capture location';

  @override
  String get recapture => 'Re-capture';

  @override
  String get capture => 'Capture';

  @override
  String get capturePhotosLabel => 'Capture Photos';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get waterSourceTypeLabel => 'Water / Source Type';

  @override
  String get agencyLabel => 'Agency';

  @override
  String get wardLabel => 'Ward';

  @override
  String get typeLabel => 'Type';

  @override
  String get areaLabel => 'Area';

  @override
  String get codeNameLabel => 'Code / Name';

  @override
  String get codeNameHelperText =>
      'Code / Name options depend on the selected ward.';

  @override
  String get selectPrefix => 'Select';

  @override
  String get chlorineMeterTestLabel => 'Chlorino Meter Test *';

  @override
  String get chlorineHint => '0.00';

  @override
  String get ppmUnit => 'ppm';

  @override
  String get specialRequestLabel => 'Special Request with Reason';

  @override
  String get specialRequestHint =>
      'Describe any special testing requests and reason…';

  @override
  String get additionalInfoLabel => 'Any Additional Relevant Information';

  @override
  String get additionalInfoHint =>
      'e.g. recent complaints, visible contamination…';

  @override
  String get specificParamsLabel => 'Specific Parameters to be Tested';

  @override
  String get specificParamsHint => 'e.g. pH, Turbidity, E.coli, TDS, Hardness…';

  @override
  String get requiredField => 'Required';

  @override
  String get enterValidMobileNumber => 'Enter valid 10-digit number';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get pleaseCaptureLocation => 'Please capture location';

  @override
  String errorLoadingFormData(String error) {
    return 'Error loading form data: $error';
  }

  @override
  String failedToLoadSourceCodes(String error) {
    return 'Failed to load source codes: $error';
  }

  @override
  String get locationServicesDisabled => 'Location services are disabled.';

  @override
  String get locationPermissionDenied => 'Location permissions are denied';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permissions are permanently denied, we cannot request permissions.';

  @override
  String errorFetchingLocation(String error) {
    return 'Error fetching location: $error';
  }

  @override
  String get captureFromCamera => 'Capture from Camera';

  @override
  String get chooseFromGalleryMultiple => 'Choose from Gallery (Multiple)';

  @override
  String get formSavedSomeImagesFailed =>
      'Form saved, but some images failed to upload.';

  @override
  String errorWithMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get pleaseFillAllRequiredFields => 'Please fill all required fields.';

  @override
  String get success => 'Success';

  @override
  String get originalNoLabel => 'Original No: ';

  @override
  String get notAvailable => 'N/A';

  @override
  String get ok => 'OK';

  @override
  String get submitSampleForm => 'Submit Sample Form';

  @override
  String get submitting => 'Submitting…';

  @override
  String get historyAppBarSubtitle => 'Sample History';

  @override
  String get refresh => 'Refresh';

  @override
  String get retry => 'Retry';

  @override
  String get searchHistoryHint => 'Search by Original No, Ward...';

  @override
  String get recentSubmissions => 'Recent Submissions';

  @override
  String recordsCount(int count) {
    return '$count Records';
  }

  @override
  String get columnOriginalNo => 'Original No.';

  @override
  String get columnWard => 'Ward';

  @override
  String get columnType => 'Type';

  @override
  String get columnDate => 'Date';

  @override
  String get columnDetails => 'Details';

  @override
  String get sampleDetails => 'Sample Details';

  @override
  String get generalInfo => 'General Info';

  @override
  String get collectorInfo => 'Collector Info';

  @override
  String get locationSource => 'Location & Source';

  @override
  String get testingInfo => 'Testing Info';

  @override
  String get uploadedDocuments => 'Uploaded Documents';

  @override
  String get noDocumentsFound => 'No documents found.';

  @override
  String get couldNotOpenDocument => 'Could not open the document link.';

  @override
  String get detailOriginalNo => 'Original No';

  @override
  String get detailStatus => 'Status';

  @override
  String get detailDate => 'Date';

  @override
  String get detailTime => 'Time';

  @override
  String get detailName => 'Name';

  @override
  String get detailMobile => 'Mobile';

  @override
  String get detailEmail => 'Email';

  @override
  String get detailWard => 'Ward';

  @override
  String get detailArea => 'Area';

  @override
  String get detailSourceType => 'Source Type';

  @override
  String get detailAgency => 'Agency';

  @override
  String get detailCodeId => 'Code ID';

  @override
  String get detailCodeName => 'Code Name';

  @override
  String get detailWeather => 'Weather';

  @override
  String get detailLatLong => 'Lat/Long';

  @override
  String get detailResidualChlorine => 'Residual Chlorine';

  @override
  String get detailEnquiryType => 'Enquiry Type';

  @override
  String get detailSpecialRequest => 'Special Request';

  @override
  String get detailAdditionalInfo => 'Additional Info';

  @override
  String get detailSpecificParams => 'Specific Params';

  @override
  String pageOfLabel(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get noRecordsFound => 'No records found';

  @override
  String noResultsFor(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get clearSearch => 'Clear Search';
}
