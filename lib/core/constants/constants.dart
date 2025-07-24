import 'dart:io';

import 'package:flutter/material.dart';

const double kPadding = 20;

class AppConfig {
  static String supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  static String supabaseAnonKey =
      const String.fromEnvironment('SUPABASE_ANON_KEY');
  static String geminiApiKey = const String.fromEnvironment('GEMINI_API_KEY');
}

extension ContextExtensions on BuildContext {
  ColorScheme get myTheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  double get screenHeight => MediaQuery.sizeOf(this).height;
  double get screenWidth => MediaQuery.sizeOf(this).width;

  void closeKeyboard() => FocusScope.of(this).unfocus();

  Size get sizeAppbar {
    final height = AppBar().preferredSize.height;

    return Size(
      screenWidth,
      height +
          (Platform.isWindows
              ? 75
              : Platform.isIOS
              ? 50
              : 70),
    );
  }
}
