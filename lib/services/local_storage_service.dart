import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../core/constants/app_constants.dart';

class LocalStorageService {
  LocalStorageService({
    required Box settingsBox,
    required Box favoritesBox,
    required Box recentBox,
  }) : _settingsBox = settingsBox,
       _favoritesBox = favoritesBox,
       _recentBox = recentBox;

  final Box _settingsBox;
  final Box _favoritesBox;
  final Box _recentBox;

  ThemeMode loadThemeMode() {
    final stored = _settingsBox.get(AppConstants.keyThemeMode) as String?;
    switch (stored) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await _settingsBox.put(AppConstants.keyThemeMode, value);
  }

  bool isOnboardingComplete() {
    return _settingsBox.get(AppConstants.keyOnboardingComplete) == true;
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _settingsBox.put(AppConstants.keyOnboardingComplete, value);
  }

  Set<String> loadFavorites() {
    final raw = _favoritesBox.get(AppConstants.keyFavorites) as List<dynamic>?;
    return raw?.map((item) => item.toString()).toSet() ?? <String>{};
  }

  Future<void> saveFavorites(Set<String> ids) async {
    await _favoritesBox.put(AppConstants.keyFavorites, ids.toList());
  }

  List<String> loadRecent() {
    final raw = _recentBox.get(AppConstants.keyRecent) as List<dynamic>?;
    return raw?.map((item) => item.toString()).toList() ?? <String>[];
  }

  Future<void> saveRecent(List<String> ids) async {
    await _recentBox.put(AppConstants.keyRecent, ids);
  }
}
