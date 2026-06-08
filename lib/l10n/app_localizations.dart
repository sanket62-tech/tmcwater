import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mr'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @waterCollector.
  ///
  /// In en, this message translates to:
  /// **'Water Collector'**
  String get waterCollector;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @sampleFormAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Testing'**
  String get sampleFormAppBarTitle;

  /// No description provided for @sampleFormAppBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sample Collection Form'**
  String get sampleFormAppBarSubtitle;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @collectorInformation.
  ///
  /// In en, this message translates to:
  /// **'Collector Information'**
  String get collectorInformation;

  /// No description provided for @locationDetails.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get locationDetails;

  /// No description provided for @sampleSourceClassification.
  ///
  /// In en, this message translates to:
  /// **'Sample Source & Classification'**
  String get sampleSourceClassification;

  /// No description provided for @additionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get additionalDetails;

  /// No description provided for @stepInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get stepInfo;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocation;

  /// No description provided for @stepSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get stepSource;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepDetails;

  /// No description provided for @collectedDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Collected Date *'**
  String get collectedDateLabel;

  /// No description provided for @collectedDateHint.
  ///
  /// In en, this message translates to:
  /// **'DD / MM / YYYY'**
  String get collectedDateHint;

  /// No description provided for @collectedTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Collected Time *'**
  String get collectedTimeLabel;

  /// No description provided for @collectedTimeHint.
  ///
  /// In en, this message translates to:
  /// **'HH : MM'**
  String get collectedTimeHint;

  /// No description provided for @collectorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Collector Name *'**
  String get collectorNameLabel;

  /// No description provided for @collectorNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get collectorNameHint;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number *'**
  String get mobileNumberLabel;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get mobileNumberHint;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressLabel;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'collector@tmc.gov.in (optional)'**
  String get emailAddressHint;

  /// No description provided for @weatherConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Weather Conditions *'**
  String get weatherConditionsLabel;

  /// No description provided for @selectWeatherHint.
  ///
  /// In en, this message translates to:
  /// **'Select weather'**
  String get selectWeatherHint;

  /// No description provided for @geoTaggingLabel.
  ///
  /// In en, this message translates to:
  /// **'Geo-tagging *'**
  String get geoTaggingLabel;

  /// No description provided for @tapToCaptureLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to capture location'**
  String get tapToCaptureLocation;

  /// No description provided for @recapture.
  ///
  /// In en, this message translates to:
  /// **'Re-capture'**
  String get recapture;

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @capturePhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Capture Photos'**
  String get capturePhotosLabel;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @waterSourceTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Water / Source Type'**
  String get waterSourceTypeLabel;

  /// No description provided for @agencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Agency'**
  String get agencyLabel;

  /// No description provided for @wardLabel.
  ///
  /// In en, this message translates to:
  /// **'Ward'**
  String get wardLabel;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @areaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaLabel;

  /// No description provided for @codeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Code / Name'**
  String get codeNameLabel;

  /// No description provided for @codeNameHelperText.
  ///
  /// In en, this message translates to:
  /// **'Code / Name options depend on the selected ward.'**
  String get codeNameHelperText;

  /// No description provided for @selectPrefix.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectPrefix;

  /// No description provided for @chlorineMeterTestLabel.
  ///
  /// In en, this message translates to:
  /// **'Chlorino Meter Test *'**
  String get chlorineMeterTestLabel;

  /// No description provided for @chlorineHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get chlorineHint;

  /// No description provided for @ppmUnit.
  ///
  /// In en, this message translates to:
  /// **'ppm'**
  String get ppmUnit;

  /// No description provided for @specialRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'Special Request with Reason'**
  String get specialRequestLabel;

  /// No description provided for @specialRequestHint.
  ///
  /// In en, this message translates to:
  /// **'Describe any special testing requests and reason…'**
  String get specialRequestHint;

  /// No description provided for @additionalInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Any Additional Relevant Information'**
  String get additionalInfoLabel;

  /// No description provided for @additionalInfoHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. recent complaints, visible contamination…'**
  String get additionalInfoHint;

  /// No description provided for @specificParamsLabel.
  ///
  /// In en, this message translates to:
  /// **'Specific Parameters to be Tested'**
  String get specificParamsLabel;

  /// No description provided for @specificParamsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. pH, Turbidity, E.coli, TDS, Hardness…'**
  String get specificParamsHint;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @enterValidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter valid 10-digit number'**
  String get enterValidMobileNumber;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @pleaseCaptureLocation.
  ///
  /// In en, this message translates to:
  /// **'Please capture location'**
  String get pleaseCaptureLocation;

  /// No description provided for @errorLoadingFormData.
  ///
  /// In en, this message translates to:
  /// **'Error loading form data: {error}'**
  String errorLoadingFormData(String error);

  /// No description provided for @failedToLoadSourceCodes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load source codes: {error}'**
  String failedToLoadSourceCodes(String error);

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied, we cannot request permissions.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @errorFetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error fetching location: {error}'**
  String errorFetchingLocation(String error);

  /// No description provided for @captureFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Capture from Camera'**
  String get captureFromCamera;

  /// No description provided for @chooseFromGalleryMultiple.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery (Multiple)'**
  String get chooseFromGalleryMultiple;

  /// No description provided for @formSavedSomeImagesFailed.
  ///
  /// In en, this message translates to:
  /// **'Form saved, but some images failed to upload.'**
  String get formSavedSomeImagesFailed;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithMessage(String error);

  /// No description provided for @pleaseFillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields.'**
  String get pleaseFillAllRequiredFields;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @originalNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Original No: '**
  String get originalNoLabel;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @submitSampleForm.
  ///
  /// In en, this message translates to:
  /// **'Submit Sample Form'**
  String get submitSampleForm;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get submitting;

  /// No description provided for @historyAppBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sample History'**
  String get historyAppBarSubtitle;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @searchHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search by Original No, Ward...'**
  String get searchHistoryHint;

  /// No description provided for @recentSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Recent Submissions'**
  String get recentSubmissions;

  /// No description provided for @recordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Records'**
  String recordsCount(int count);

  /// No description provided for @columnOriginalNo.
  ///
  /// In en, this message translates to:
  /// **'Original No.'**
  String get columnOriginalNo;

  /// No description provided for @columnWard.
  ///
  /// In en, this message translates to:
  /// **'Ward'**
  String get columnWard;

  /// No description provided for @columnType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get columnType;

  /// No description provided for @columnDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get columnDate;

  /// No description provided for @columnDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get columnDetails;

  /// No description provided for @sampleDetails.
  ///
  /// In en, this message translates to:
  /// **'Sample Details'**
  String get sampleDetails;

  /// No description provided for @generalInfo.
  ///
  /// In en, this message translates to:
  /// **'General Info'**
  String get generalInfo;

  /// No description provided for @collectorInfo.
  ///
  /// In en, this message translates to:
  /// **'Collector Info'**
  String get collectorInfo;

  /// No description provided for @locationSource.
  ///
  /// In en, this message translates to:
  /// **'Location & Source'**
  String get locationSource;

  /// No description provided for @testingInfo.
  ///
  /// In en, this message translates to:
  /// **'Testing Info'**
  String get testingInfo;

  /// No description provided for @uploadedDocuments.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Documents'**
  String get uploadedDocuments;

  /// No description provided for @noDocumentsFound.
  ///
  /// In en, this message translates to:
  /// **'No documents found.'**
  String get noDocumentsFound;

  /// No description provided for @couldNotOpenDocument.
  ///
  /// In en, this message translates to:
  /// **'Could not open the document link.'**
  String get couldNotOpenDocument;

  /// No description provided for @detailOriginalNo.
  ///
  /// In en, this message translates to:
  /// **'Original No'**
  String get detailOriginalNo;

  /// No description provided for @detailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get detailStatus;

  /// No description provided for @detailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get detailDate;

  /// No description provided for @detailTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get detailTime;

  /// No description provided for @detailName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get detailName;

  /// No description provided for @detailMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get detailMobile;

  /// No description provided for @detailEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get detailEmail;

  /// No description provided for @detailWard.
  ///
  /// In en, this message translates to:
  /// **'Ward'**
  String get detailWard;

  /// No description provided for @detailArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get detailArea;

  /// No description provided for @detailSourceType.
  ///
  /// In en, this message translates to:
  /// **'Source Type'**
  String get detailSourceType;

  /// No description provided for @detailAgency.
  ///
  /// In en, this message translates to:
  /// **'Agency'**
  String get detailAgency;

  /// No description provided for @detailCodeId.
  ///
  /// In en, this message translates to:
  /// **'Code ID'**
  String get detailCodeId;

  /// No description provided for @detailCodeName.
  ///
  /// In en, this message translates to:
  /// **'Code Name'**
  String get detailCodeName;

  /// No description provided for @detailWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get detailWeather;

  /// No description provided for @detailLatLong.
  ///
  /// In en, this message translates to:
  /// **'Lat/Long'**
  String get detailLatLong;

  /// No description provided for @detailResidualChlorine.
  ///
  /// In en, this message translates to:
  /// **'Residual Chlorine'**
  String get detailResidualChlorine;

  /// No description provided for @detailEnquiryType.
  ///
  /// In en, this message translates to:
  /// **'Enquiry Type'**
  String get detailEnquiryType;

  /// No description provided for @detailSpecialRequest.
  ///
  /// In en, this message translates to:
  /// **'Special Request'**
  String get detailSpecialRequest;

  /// No description provided for @detailAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get detailAdditionalInfo;

  /// No description provided for @detailSpecificParams.
  ///
  /// In en, this message translates to:
  /// **'Specific Params'**
  String get detailSpecificParams;

  /// No description provided for @pageOfLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOfLabel(int current, int total);

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecordsFound;

  /// No description provided for @noResultsFor.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String noResultsFor(String query);

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
