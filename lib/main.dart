import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/providers.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final settingsBox = await Hive.openBox(AppConstants.boxSettings);
  final favoritesBox = await Hive.openBox(AppConstants.boxFavorites);
  final recentBox = await Hive.openBox(AppConstants.boxRecent);

  final storageService = LocalStorageService(
    settingsBox: settingsBox,
    favoritesBox: favoritesBox,
    recentBox: recentBox,
  );

  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storageService)],
      child: const ShortcutKeysHubApp(),
    ),
  );
}
