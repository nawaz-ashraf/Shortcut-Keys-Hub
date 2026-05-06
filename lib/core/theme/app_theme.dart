import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final base = ThemeData(brightness: Brightness.light, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppConstants.lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.darkAccent,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      cardColor: AppConstants.lightSurface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppConstants.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.darkAccent,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme,
      ).apply(bodyColor: Colors.white),
      cardColor: AppConstants.darkCard,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
