import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_schemes.g.dart';

final darkThemeApp = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: darkColorSchemePapagaio,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorSchemePapagaio.primaryContainer,
    centerTitle: true,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  scaffoldBackgroundColor: darkColorSchemePapagaio.surface,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => darkColorSchemePapagaio.onSurface,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => darkColorSchemePapagaio.primaryContainer,
      ),
    ),
  ),
);
