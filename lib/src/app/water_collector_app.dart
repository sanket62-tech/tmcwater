import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:water_collector/src/core/constants/app_constants.dart';
import 'package:water_collector/src/core/routes/app_routes.dart';
import 'package:water_collector/src/core/theme/app_theme.dart';
import 'package:water_collector/src/core/providers/locale_provider.dart';

import '../../l10n/app_localizations.dart';

class WaterCollectorApp extends StatelessWidget {
  const WaterCollectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('mr'),
            ],
          );
        },
      ),
    );
  }
}
