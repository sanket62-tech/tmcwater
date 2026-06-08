import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:water_collector/src/features/sample_form/data/models/dropdown_model.dart';
import 'package:water_collector/src/features/sample_form/data/services/sample_form_api_service.dart';
import 'package:water_collector/src/features/sample_form/data/models/water_sample_model.dart';
import 'package:water_collector/src/core/services/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:water_collector/src/features/home/presentation/screens/main_screen.dart';
import 'package:water_collector/l10n/app_localizations.dart';





class JalNamunaApp extends StatelessWidget {
  const JalNamunaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Testing – BMC',
      theme: AppTheme.theme,
      home: const SampleCollectionFormPage(),
    );
  }
}


class AppTheme {
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color accent = Color(0xFF00ACC1);
  static const Color surface = Color(0xFFF0F7FF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFBBDEFB);
  static const Color labelColor = Color(0xFF37474F);
  static const Color hintColor = Color(0xFF90A4AE);
  static const Color success = Color(0xFF00897B);
  static const Color sectionHeaderBg = Color(0xFF1565C0);

  // Section accent colors
  static const List<Color> sectionColors = [
    Color(0xFF1565C0), // Collector Info  – deep blue
    Color(0xFF00838F), // Location        – teal
    Color(0xFF2E7D32), // Source & Class  – green
    Color(0xFF6A1B9A), // Additional      – purple
  ];

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: primary,
    scaffoldBackgroundColor: surface,
    fontFamily: 'Poppins', // add to pubspec if available; falls back gracefully
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1.8),
      ),
      labelStyle: const TextStyle(
          color: labelColor, fontSize: 13.5, fontWeight: FontWeight.w500),
      hintStyle: TextStyle(color: hintColor, fontSize: 13),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
//  FORM PAGE
// ─────────────────────────────────────────────────────────────
class SampleCollectionFormPage extends StatefulWidget {
  const SampleCollectionFormPage({super.key});

  @override
  State<SampleCollectionFormPage> createState() =>
      _SampleCollectionFormPageState();
}

class _SampleCollectionFormPageState extends State<SampleCollectionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _scroll = ScrollController();

  /// Shorthand accessor for the localized strings — safe to use both inside
  /// `build()` and in async callbacks (the State's `context` stays valid for
  /// as long as the widget is mounted).
  AppLocalizations get _l10n => AppLocalizations.of(context)!;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // ── Section 1 ──
  DateTime? _collectedDate;
  TimeOfDay? _collectedTime;
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  // ── Section 2 ──
  String? _weatherCondition;
  String _geoTag = 'Tap to capture location';
  bool _geoLoading = false;
  double _lat = 0.0;
  double _lng = 0.0;
  final List<String> _capturedPhotos = []; // paths / mock

  // ── Section 3 ──
  final SampleFormApiService _sampleFormApi = SampleFormApiService();

  List<DropdownModel> _sourceTypes = [];
  List<DropdownModel> _agencies = [];
  List<DropdownModel> _wards = [];
  List<DropdownModel> _enquiryTypes = [];
  List<DropdownModel> _areas = [];
  List<DropdownModel> _sourceCodes = [];

  bool _isLoadingDropdowns = false;
  bool _isLoadingSourceCodes = false;
  bool _isSubmitting = false;

  DropdownModel? _selectedSourceType;
  DropdownModel? _selectedAgency;
  DropdownModel? _selectedWard;
  DropdownModel? _selectedEnquiryType;
  DropdownModel? _selectedArea;
  DropdownModel? _selectedSourceCode;

  final _codeCtrl = TextEditingController();

  // ── Section 4 ──
  final _chlorineCtrl = TextEditingController();
  final _specialRequestCtrl = TextEditingController();
  final _additionalInfoCtrl = TextEditingController();
  final _specificParamsCtrl = TextEditingController();

  static const List<String> _weatherOptions = [
    'Sunny',
    'Cloudy',
    'Rainy',
    'Partly Cloudy',
    'Foggy',
    'Stormy',
  ];

  // ── Ward → code prefix map ──
  String get _codePrefix {
    if (_selectedWard == null) return 'WARD-X01';
    final w = _selectedWard!.name.replaceAll('Ward ', '').replaceAll('/', '');
    return '${w}X01';
  }

  @override
  void initState() {
    super.initState();
    _collectedDate = DateTime.now();
    _collectedTime = TimeOfDay.now();
    _loadUserData();
    _fetchAllDropdownData();
  }

  Future<void> _loadUserData() async {
    final userData = await StorageService().getUserData();
    if (userData != null) {
      setState(() {
        if (userData.fullName != null) {
          _nameCtrl.text = userData.fullName!;
        }
        if (userData.email != null) {
          _emailCtrl.text = userData.email!;
        }
      });
    }
  }

  Future<void> _fetchAllDropdownData() async {
    if (!mounted) return;
    setState(() => _isLoadingDropdowns = true);

    try {
      print('--- FETCHING ALL DROPDOWNS ---');
      final results = await Future.wait([
        _sampleFormApi.getSourceTypes().catchError((e) {
          print('Error fetching source types: $e');
          return <DropdownModel>[];
        }),
        _sampleFormApi.getAgencies().catchError((e) {
          print('Error fetching agencies: $e');
          return <DropdownModel>[];
        }),
        _sampleFormApi.getWards().catchError((e) {
          print('Error fetching wards: $e');
          return <DropdownModel>[];
        }),
        _sampleFormApi.getEnquiryTypes().catchError((e) {
          print('Error fetching enquiry types: $e');
          return <DropdownModel>[];
        }),
        _sampleFormApi.getAreas().catchError((e) {
          print('Error fetching areas: $e');
          return <DropdownModel>[];
        }),
      ]);

      if (!mounted) return;

      setState(() {
        _sourceTypes = results[0];
        _agencies = results[1];
        _wards = results[2];
        _enquiryTypes = results[3];
        _areas = results[4];

        _isLoadingDropdowns = false;
      });
      print('--- ALL DROPDOWNS LOADED ---');
    } catch (e) {
      print('Unexpected error in _fetchAllDropdownData: $e');
      if (mounted) {
        setState(() => _isLoadingDropdowns = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_l10n.errorLoadingFormData(e.toString()))),
        );
      }
    }
  }

  Future<void> _fetchSourceCodes(int wardId) async {
    setState(() {
      _isLoadingSourceCodes = true;
      _sourceCodes = [];
      _selectedSourceCode = null;
    });

    try {
      final codes = await _sampleFormApi.getSourceCodes(wardId);
      if (mounted) {
        setState(() {
          _sourceCodes = codes;
          _isLoadingSourceCodes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingSourceCodes = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_l10n.failedToLoadSourceCodes(e.toString()))),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _codeCtrl.dispose();
    _chlorineCtrl.dispose();
    _specialRequestCtrl.dispose();
    _additionalInfoCtrl.dispose();
    _specificParamsCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
          const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _collectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
          const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (t != null) setState(() => _collectedTime = t);
  }

  Future<void> _captureGeoTag() async {
    setState(() => _geoLoading = true);

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _geoLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_l10n.locationServicesDisabled)),
          );
        }
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _geoLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_l10n.locationPermissionDenied)),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _geoLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_l10n.locationPermissionPermanentlyDenied)),
          );
        }
        return;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _geoLoading = false;
        _lat = position.latitude;
        _lng = position.longitude;
        _geoTag = '${position.latitude.toStringAsFixed(6)}° N, ${position.longitude.toStringAsFixed(6)}° E';
      });
    } catch (e) {
      setState(() => _geoLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_l10n.errorFetchingLocation(e.toString()))),
        );
      }
    }
  }

  Future<void> _addPhoto() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppTheme.primary),
                title: Text(_l10n.captureFromCamera),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    setState(() => _capturedPhotos.add(photo.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppTheme.primary),
                title: Text(_l10n.chooseFromGalleryMultiple),
                onTap: () async {
                  Navigator.pop(context);
                  final List<XFile> images = await picker.pickMultiImage();
                  if (images.isNotEmpty) {
                    setState(() {
                      for (var img in images) {
                        _capturedPhotos.add(img.path);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removePhoto(int index) {
    setState(() => _capturedPhotos.removeAt(index));
  }

  Future<void> _submitForm() async {
    // Unfocus any active text field to close keyboard before showing dialog
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        final userData = await StorageService().getUserData();
        if (userData == null || userData.userId == null) {
          throw 'User not logged in';
        }

        final request = WaterSampleInsertRequest(
          userId: userData.userId!,
          collectedDate: DateFormat('yyyy-MM-dd').format(_collectedDate ?? DateTime.now()),
          collectedTime: _collectedTime?.format(context) ?? '',
          collectorName: _nameCtrl.text.trim(),
          mobileNumber: _mobileCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          waterSourceType: _selectedSourceType?.id ?? 0,
          agency: _selectedAgency?.id ?? 0,
          ward: _selectedWard?.id ?? 0,
          type: _selectedEnquiryType?.id ?? 0,
          area: _selectedArea?.id ?? 0,
          codeName: _selectedSourceCode?.id ?? 1,
          chlorinoMeterTest: double.tryParse(_chlorineCtrl.text) ?? 0.0,
          specialRequestWithReason: _specialRequestCtrl.text.trim(),
          additionalRelevantInformation: _additionalInfoCtrl.text.trim(),
          specificParametersToBeTested: _specificParamsCtrl.text.trim(),
          weatherConditions: _weatherCondition ?? '',
          latitude: _lat,
          longitude: _lng,
          statusId: 1,
          createdBy: userData.userId!,
          isFromMobile: 1,
        );

        final response = await _sampleFormApi.insertWaterSampleDetails(request);

        // --- Start Image Upload Flow ---
        if (response.success && _capturedPhotos.isNotEmpty) {
          try {
            print('--- STARTING IMAGE UPLOAD ---');
            await _sampleFormApi.uploadDocuments(
              filePaths: _capturedPhotos,
              originalNo: response.originalNo ?? '',
              userId: userData.userId!,
            );
            print('--- IMAGE UPLOAD SUCCESS ---');
          } catch (uploadError) {
            print('Error during image upload: $uploadError');
            // We still show the success dialog for the form, but maybe warn about images
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_l10n.formSavedSomeImagesFailed),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        }
        // --- End Image Upload Flow ---

        setState(() => _isSubmitting = false);

        if (response.success) {
          _showSuccessDialog(response);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      } catch (e) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_l10n.errorWithMessage(e.toString()))),
        );
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Icon(Icons.error_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(_l10n.pleaseFillAllRequiredFields,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }
  }

  void _showSuccessDialog(WaterSampleResponse response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 28),
            const SizedBox(width: 10),
            Text(_l10n.success, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(response.message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Text(_l10n.originalNoLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(response.originalNo ?? _l10n.notAvailable,
                      style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // 1. Unfocus and close keyboard immediately
                FocusScope.of(context).unfocus();
                
                // 2. Close the dialog first
                Navigator.pop(ctx);

                // 3. Small delay to ensure dialog starts closing
                await Future.delayed(const Duration(milliseconds: 100));

                // 4. Navigate to Home (Page 0)
                final mainScreen = context.findAncestorStateOfType<MainScreenState>();
                if (mainScreen != null) {
                  mainScreen.setPage(0);
                  
                  // 5. Wait for the PageView transition (400ms in MainScreen)
                  // to finish before clearing the form to avoid visual glitches.
                  await Future.delayed(const Duration(milliseconds: 450));
                }

                // 6. Finally clear the form and reset validation
                if (mounted) {
                  _clearForm();
                  // 7. Ensure focus is completely cleared after form reset
                  FocusScope.of(context).unfocus();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(_l10n.ok,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _autovalidateMode = AutovalidateMode.disabled;
      _collectedDate = DateTime.now();
      _collectedTime = TimeOfDay.now();
      _nameCtrl.clear();
      _mobileCtrl.clear();
      _emailCtrl.clear();
      _weatherCondition = null;
      _geoTag = _l10n.tapToCaptureLocation;
      _lat = 0.0;
      _lng = 0.0;
      _capturedPhotos.clear();
      _selectedSourceType = null;
      _selectedAgency = null;
      _selectedWard = null;
      _selectedEnquiryType = null;
      _selectedArea = null;
      _selectedSourceCode = null;
      _sourceCodes = [];
      _chlorineCtrl.clear();
      _specialRequestCtrl.clear();
      _additionalInfoCtrl.clear();
      _specificParamsCtrl.clear();
    });
    _loadUserData();
    _scroll.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tapping anywhere outside an input drops the keyboard / focus instead
      // of leaving it stuck on whatever field happens to be focused.
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppTheme.surface,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(),
        body: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              _ProgressStepper(currentSection: 4),
              const SizedBox(height: 18),
              _buildFormSections(),
              const SizedBox(height: 28),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Whole form, laid out as a single continuous flow of softly-tinted
  /// "group" cards — each its own rounded panel with a compact icon-badge
  /// heading and a slim colour-accent underline (no full-width banner bars,
  /// no collapsible sections — everything is visible at once).
  Widget _buildFormSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGroupPanel(
          icon: Icons.person_pin_rounded,
          title: _l10n.collectorInformation,
          accent: AppTheme.sectionColors[0],
          fields: _collectorInfoFields(),
        ),
        const SizedBox(height: 18),
        _buildGroupPanel(
          icon: Icons.location_on_rounded,
          title: _l10n.locationDetails,
          accent: AppTheme.sectionColors[1],
          fields: _locationDetailFields(),
        ),
        const SizedBox(height: 18),
        _buildGroupPanel(
          icon: Icons.water_drop_rounded,
          title: _l10n.sampleSourceClassification,
          accent: AppTheme.sectionColors[2],
          fields: _sourceClassificationFields(),
        ),
        const SizedBox(height: 18),
        _buildGroupPanel(
          icon: Icons.science_rounded,
          title: _l10n.additionalDetails,
          accent: AppTheme.sectionColors[3],
          fields: _additionalDetailFields(),
        ),
      ],
    );
  }

  /// A single rounded, softly-tinted panel: icon badge + title + accent
  /// underline, followed by its fields. Replaces the old bold gradient
  /// section header bars with a calmer, modern card treatment.
  Widget _buildGroupPanel({
    required IconData icon,
    required String title,
    required Color accent,
    required List<Widget> fields,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.16), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent.withOpacity(0.20), accent.withOpacity(0.08)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.labelColor,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 58),
            height: 3.5,
            width: 50,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 22),
          ...fields,
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('TMC',
                style: TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_l10n.sampleFormAppBarTitle,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5)),
              Text(_l10n.sampleFormAppBarSubtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          onPressed: () {},
          tooltip: _l10n.help,
        ),
      ],
    );
  }

  // ─────────────────────────── COLLECTOR INFO FIELDS ───────────────────────────
  List<Widget> _collectorInfoFields() {
    return [
        // Date & Time in a row
        Row(
          children: [
            Expanded(
              child: _TappableField(
                label: _l10n.collectedDateLabel,
                icon: Icons.calendar_today_rounded,
                value: _collectedDate == null
                    ? null
                    : '${_collectedDate!.day.toString().padLeft(2, '0')}/'
                    '${_collectedDate!.month.toString().padLeft(2, '0')}/'
                    '${_collectedDate!.year}',
                hint: _l10n.collectedDateHint,
                onTap: null, // Made uneditable
                validator: (_) =>
                _collectedDate == null ? _l10n.requiredField : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TappableField(
                label: _l10n.collectedTimeLabel,
                icon: Icons.access_time_rounded,
                value: _collectedTime?.format(context),
                hint: _l10n.collectedTimeHint,
                onTap: _pickTime,
                validator: (_) =>
                _collectedTime == null ? _l10n.requiredField : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _nameCtrl,
          label: _l10n.collectorNameLabel,
          hint: _l10n.collectorNameHint,
          icon: Icons.badge_rounded,
          readOnly: true, // Made uneditable
          validator: (v) =>
          (v == null || v.trim().isEmpty) ? _l10n.requiredField : null,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _mobileCtrl,
          label: _l10n.mobileNumberLabel,
          hint: _l10n.mobileNumberHint,
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (v) {
            if (v == null || v.isEmpty) return _l10n.requiredField;
            if (v.length != 10) return _l10n.enterValidMobileNumber;
            return null;
          },
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _emailCtrl,
          label: _l10n.emailAddressLabel,
          hint: _l10n.emailAddressHint,
          icon: Icons.email_rounded,
          readOnly: true, // Made uneditable
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            // Email is optional — only validate format when something is entered.
            if (v == null || v.trim().isEmpty) return null;
            final reg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            return reg.hasMatch(v.trim()) ? null : _l10n.invalidEmail;
          },
        ),
    ];
  }

  // ─────────────────────────── LOCATION DETAIL FIELDS ───────────────────────────
  List<Widget> _locationDetailFields() {
    return [
        // Weather dropdown
        _LabelText(_l10n.weatherConditionsLabel),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _weatherCondition,
          decoration: InputDecoration(
            prefixIcon:
            const Icon(Icons.wb_cloudy_rounded, color: AppTheme.primary),
            hintText: _l10n.selectWeatherHint,
          ),
          items: _weatherOptions
              .map((w) => DropdownMenuItem(value: w, child: Text(w)))
              .toList(),
          onChanged: (v) => setState(() => _weatherCondition = v),
          validator: (v) => v == null ? _l10n.requiredField : null,
          borderRadius: BorderRadius.circular(12),
        ),
        const SizedBox(height: 14),

        // Geo-tagging
        _LabelText(_l10n.geoTaggingLabel),
        const SizedBox(height: 6),
        FormField<String>(
          validator: (_) =>
          !_geoTag.contains('°') ? _l10n.pleaseCaptureLocation : null,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    await _captureGeoTag();
                    state.didChange(_geoTag);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: state.hasError
                            ? Colors.red
                            : _geoTag.contains('°')
                            ? AppTheme.success
                            : AppTheme.border,
                        width: 1.3,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location_rounded,
                          color: _geoTag.contains('°')
                              ? AppTheme.success
                              : AppTheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _geoTag,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: _geoTag.contains('°')
                                  ? AppTheme.labelColor
                                  : AppTheme.hintColor,
                              fontWeight: _geoTag.contains('°')
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (_geoLoading)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppTheme.accent),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppTheme.sectionColors[1].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _geoTag.contains('°') ? _l10n.recapture : _l10n.capture,
                              style: TextStyle(
                                color: AppTheme.sectionColors[1],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Text(state.errorText!,
                        style:
                        const TextStyle(color: Colors.red, fontSize: 11.5)),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 14),

        // Photo capture
        _LabelText(_l10n.capturePhotosLabel),
        const SizedBox(height: 6),
        _PhotoGrid(
          photos: _capturedPhotos,
          onAdd: _addPhoto,
          onRemove: _removePhoto,
          accentColor: AppTheme.primary,
        ),
    ];
  }

  // ─────────────────────────── SOURCE CLASSIFICATION FIELDS ───────────────────────────
  List<Widget> _sourceClassificationFields() {
    return [
        _isLoadingDropdowns
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        )
            : Column(
          children: [
            _buildDropdown<DropdownModel>(
              label: _l10n.waterSourceTypeLabel,
              icon: Icons.water_rounded,
              value: _selectedSourceType,
              items: _sourceTypes,
              color: AppTheme.primary,
              onChanged: (v) => setState(() => _selectedSourceType = v),
              itemLabel: (t) => t.name,
              validator: (v) => v == null ? _l10n.requiredField : null,
            ),
            const SizedBox(height: 14),
            _buildDropdown<DropdownModel>(
              label: _l10n.agencyLabel,
              icon: Icons.account_balance_rounded,
              value: _selectedAgency,
              items: _agencies,
              color: AppTheme.primary,
              onChanged: (v) => setState(() => _selectedAgency = v),
              itemLabel: (t) => t.name,
              validator: (v) => v == null ? _l10n.requiredField : null,
            ),
            const SizedBox(height: 14),
            _buildDropdown<DropdownModel>(
              label: _l10n.wardLabel,
              icon: Icons.map_rounded,
              value: _selectedWard,
              items: _wards,
              color: AppTheme.primary,
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    _selectedWard = v;
                    _fetchSourceCodes(v.id);
                  });
                }
              },
              itemLabel: (t) => t.name,
              validator: (v) => v == null ? _l10n.requiredField : null,
            ),
            const SizedBox(height: 14),
            _buildDropdown<DropdownModel>(
              label: _l10n.typeLabel,
              icon: Icons.category_rounded,
              value: _selectedEnquiryType,
              items: _enquiryTypes,
              color: AppTheme.primary,
              onChanged: (v) => setState(() => _selectedEnquiryType = v),
              itemLabel: (t) => t.name,
              validator: (v) => v == null ? _l10n.requiredField : null,
            ),
            const SizedBox(height: 14),
            _buildDropdown<DropdownModel>(
              label: _l10n.areaLabel,
              icon: Icons.location_city_rounded,
              value: _selectedArea,
              items: _areas,
              color: AppTheme.primary,
              onChanged: (v) => setState(() => _selectedArea = v),
              itemLabel: (t) => t.name,
              validator: (v) => v == null ? _l10n.requiredField : null,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Code / Name Dropdown
        _isLoadingSourceCodes
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown<DropdownModel>(
              label: _l10n.codeNameLabel,
              icon: Icons.qr_code_rounded,
              value: _selectedSourceCode,
              items: _sourceCodes,
              color: AppTheme.primary,
              onChanged: (v) => setState(() => _selectedSourceCode = v),
              itemLabel: (t) => t.name,
              validator: (v) => v == null ? _l10n.requiredField : null,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 13, color: AppTheme.hintColor),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _l10n.codeNameHelperText,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.hintColor),
                  ),
                ),
              ],
            ),
          ],
        ),
    ];
  }

  // ─────────────────────────── ADDITIONAL DETAIL FIELDS ───────────────────────────
  List<Widget> _additionalDetailFields() {
    return [
        // Chlorine meter
        _LabelText(_l10n.chlorineMeterTestLabel),
        const SizedBox(height: 6),
        TextFormField(
          controller: _chlorineCtrl,
          keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          validator: (v) => (v == null || v.trim().isEmpty) ? _l10n.requiredField : null,
          decoration: InputDecoration(
            prefixIcon:   Icon(Icons.colorize_rounded,
                color: Color(0xFF1565C0)),
            prefixIconColor: AppTheme.sectionColors[3],
            hintText: _l10n.chlorineHint,
            suffixText: _l10n.ppmUnit,
            suffixStyle: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _specialRequestCtrl,
          label: _l10n.specialRequestLabel,
          hint: _l10n.specialRequestHint,
          icon: Icons.priority_high_rounded,
          maxLines: 3,
          iconColor: AppTheme.primary,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _additionalInfoCtrl,
          label: _l10n.additionalInfoLabel,
          hint: _l10n.additionalInfoHint,
          icon: Icons.info_rounded,
          maxLines: 3,
          iconColor: AppTheme.primary,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _specificParamsCtrl,
          label: _l10n.specificParamsLabel,
          hint: _l10n.specificParamsHint,
          icon: Icons.biotech_rounded,
          maxLines: 3,
          iconColor: AppTheme.primary,
        ),
    ];
  }

  // ─────────────────────────── HELPERS ───────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Color? iconColor,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: iconColor ?? AppTheme.primary, size: 20),
        alignLabelWithHint: maxLines > 1,
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.withOpacity(0.1) : Colors.white,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required Color color,
    required void Function(T?) onChanged,
    String Function(T)? itemLabel,
    String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelText('$label *'),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: (value == null || !items.contains(value)) ? null : value,
          hint: Text('${_l10n.selectPrefix} $label', style: const TextStyle(fontSize: 13, color: AppTheme.hintColor)),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: color, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: AppTheme.primary, size: 22),
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.labelColor,
            fontWeight: FontWeight.w500,
          ),
          items: items
              .map((i) => DropdownMenuItem(
            value: i,
            child: Text(
              itemLabel != null ? itemLabel(i) : i.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.labelColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ))
              .toList(),
          onChanged: onChanged,
          validator: validator,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isSubmitting
              ? [AppTheme.primary.withOpacity(0.6), AppTheme.primaryDark.withOpacity(0.6)]
              : const [AppTheme.primaryDark, AppTheme.primary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(_isSubmitting ? 0.18 : 0.38),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isSubmitting ? null : _submitForm,
          child: Center(
            child: _isSubmitting
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.6,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  _l10n.submitting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  _l10n.submitSampleForm,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  REUSABLE COMPONENTS
// ─────────────────────────────────────────────────────────────

/// Tappable read-only field (date / time / location)
class _TappableField extends FormField<String> {
  _TappableField({
    required String label,
    required IconData icon,
    required String? value,
    required String hint,
    Future<void> Function()? onTap,
    String? Function(String?)? validator,
  }) : super(
    validator: validator,
    initialValue: value,
    builder: (state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LabelText(label),
          const SizedBox(height: 6),
          InkWell(
            onTap: onTap == null
                ? null
                : () async {
              await onTap();
              state.didChange(value);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: onTap == null ? Colors.grey.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: state.hasError
                      ? Colors.red
                      : value != null
                      ? AppTheme.primary
                      : AppTheme.border,
                  width: 1.3,
                ),
              ),
              child: Row(
                children: [
                  Icon(icon,
                      size: 18,
                      color: value != null
                          ? AppTheme.primary
                          : AppTheme.hintColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value ?? hint,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: value != null
                            ? AppTheme.labelColor
                            : AppTheme.hintColor,
                      ),
                    ),
                  ),
                  if (onTap != null)
                    Icon(Icons.chevron_right_rounded,
                        color: AppTheme.hintColor, size: 18),
                ],
              ),
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(state.errorText!,
                  style: const TextStyle(
                      color: Colors.red, fontSize: 11.5)),
            ),
        ],
      );
    },
  );
}

/// Label above fields
class _LabelText extends StatelessWidget {
  final String text;
  const _LabelText(this.text);

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppTheme.labelColor,
    );

    // Highlight the trailing "required" asterisk in red so mandatory
    // fields stand out at a glance, matching the validation error color.
    if (text.trim().endsWith('*')) {
      final base = text.substring(0, text.lastIndexOf('*')).trimRight();
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            TextSpan(text: base),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      );
    }

    return Text(text, style: baseStyle);
  }
}

/// Photo grid with add button
class _PhotoGrid extends StatelessWidget {
  final List<String> photos;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final Color accentColor;

  const _PhotoGrid({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // Existing photos
        ...List.generate(photos.length, (i) {
          return Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: accentColor.withOpacity(0.3), width: 1.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(photos[i]),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_rounded,
                              color: Colors.red[300], size: 28),
                          const SizedBox(height: 4),
                          const Text(
                            'Error',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: GestureDetector(
                  onTap: () => onRemove(i),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 13),
                  ),
                ),
              ),
            ],
          );
        }),

        // Add button
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: accentColor.withOpacity(0.5),
                  width: 1.5,
                  style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_rounded,
                    color: accentColor, size: 26),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.addPhoto,
                  style: TextStyle(
                      fontSize: 10,
                      color: accentColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Mini progress stepper at top
class _ProgressStepper extends StatelessWidget {
  final int currentSection;
  const _ProgressStepper({required this.currentSection});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.stepInfo, l10n.stepLocation, l10n.stepSource, l10n.stepDetails];
    return Row(
      children: List.generate(4, (i) {
        final active = i < currentSection;
        final color = AppTheme.sectionColors[i];
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 5,
                      decoration: BoxDecoration(
                        color: active
                            ? color
                            : color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: active ? color : AppTheme.hintColor,
                        fontWeight: active
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < 3) const SizedBox(width: 4),
            ],
          ),
        );
      }),
    );
  }
}