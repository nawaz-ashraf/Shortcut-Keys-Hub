import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Shortcut Keys Hub';

  static const String boxSettings = 'settings_box';
  static const String boxFavorites = 'favorites_box';
  static const String boxRecent = 'recent_box';

  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyFavorites = 'favorite_ids';
  static const String keyRecent = 'recent_ids';

  static const int recentLimit = 30;

  // Quiz constants
  static const int quizTimerSeconds = 15;
  static const int quizQuestionCount = 10;
  static const int quizCorrectXp = 10;
  static const int quizSpeedBonusXp = 5;
  static const String keyQuizTotalXp = 'quiz_total_xp';

  static const String dataWindows = 'assets/data/windows.json';
  static const String dataMac = 'assets/data/macos.json';
  static const String dataExcel = 'assets/data/excel.json';
  static const String dataWord = 'assets/data/word.json';
  static const String dataPowerPoint = 'assets/data/powerpoint.json';
  static const String dataTally = 'assets/data/tally.json';
  static const String dataAutoCad = 'assets/data/autocad.json';
  static const String dataVsCode = 'assets/data/vscode.json';
  static const String dataChrome = 'assets/data/chrome.json';
  static const String dataPhotoshop = 'assets/data/photoshop.json';

  static const List<String> dataFiles = [
    dataWindows,
    dataMac,
    dataExcel,
    dataWord,
    dataPowerPoint,
    dataTally,
    dataAutoCad,
    dataVsCode,
    dataChrome,
    dataPhotoshop,
  ];

  static const List<String> dailyTips = [
    'Use keyboard shortcuts for repeated actions to save time daily.',
    'Group shortcuts by app to build muscle memory faster.',
    'Start with navigation shortcuts—speed gains are instant.',
    'Practice five new shortcuts per week for compounding gains.',
    'Use search to discover less-known shortcuts quickly.',
    'Favor shortcuts that reduce mouse travel.',
    'Combine shortcuts with text expanders for maximum flow.',
    'Audit your workflow weekly and add one new shortcut.',
  ];

  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkCard = Color(0xFF1A1D24);
  static const Color darkAccent = Color(0xFF7B61FF);
  static const Color darkAccentSecondary = Color(0xFF00D1FF);
  static const Color lightBackground = Color(0xFFF3F5F9);
  static const Color lightSurface = Color(0xFFE6EAF2);
}
