import 'package:flutter/material.dart';
import 'package:water_collector/src/core/services/storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  final StorageService _storage = StorageService();

  Locale get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final langCode = await _storage.getLanguageCode();
    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!['en', 'mr'].contains(locale.languageCode)) return;
    _locale = locale;
    await _storage.saveLanguageCode(locale.languageCode);
    notifyListeners();
  }
}
