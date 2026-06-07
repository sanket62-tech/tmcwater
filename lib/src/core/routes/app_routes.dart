import 'package:flutter/material.dart';
import 'package:water_collector/src/features/auth/presentation/screens/login_screen.dart';
import 'package:water_collector/src/features/home/presentation/screens/main_screen.dart';
import 'package:water_collector/src/features/sample_form/presentation/screens/sample_form.dart';
import 'package:water_collector/src/features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String sampleForm = '/sample_form';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (_) => const SplashScreen(),
      login: (_) => const LoginScreen(),
      home: (_) => const MainScreen(),
      sampleForm: (_) => const SampleCollectionFormPage(),
    };
  }
}
