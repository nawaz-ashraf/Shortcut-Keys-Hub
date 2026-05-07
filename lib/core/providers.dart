import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/favorites/favorites_notifier.dart';
import '../features/recent/recent_notifier.dart';
import '../models/shortcut.dart';
import '../repository/shortcut_repository.dart';
import '../services/local_storage_service.dart';
import '../services/shortcut_data_service.dart';
import 'theme/theme_notifier.dart';

final storageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in main()');
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier(ref.watch(storageServiceProvider));
});

final shortcutRepositoryProvider = Provider<ShortcutRepository>((ref) {
  return ShortcutRepository(const ShortcutDataService());
});

final allShortcutsProvider = FutureProvider<List<ShortcutItem>>((ref) async {
  return ref.watch(shortcutRepositoryProvider).loadAll();
});

final categoryShortcutsProvider =
    FutureProvider.family<List<ShortcutItem>, String>((ref, id) async {
      return ref.watch(shortcutRepositoryProvider).loadCategory(id);
    });

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    return FavoritesNotifier(ref.watch(storageServiceProvider));
  },
);

final recentProvider = StateNotifierProvider<RecentNotifier, List<String>>((
  ref,
) {
  return RecentNotifier(ref.watch(storageServiceProvider));
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<ShortcutItem>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final asyncShortcuts = ref.watch(allShortcutsProvider);

  return asyncShortcuts.maybeWhen(
    data: (items) {
      if (query.isEmpty) return items;
      return items
          .where(
            (item) =>
                item.shortcut.toLowerCase().contains(query) ||
                item.function.toLowerCase().contains(query) ||
                item.category.toLowerCase().contains(query),
          )
          .toList();
    },
    orElse: () => <ShortcutItem>[],
  );
});

// ─── QUIZ XP ──────────────────────────────────────────────────────────

class QuizXpNotifier extends StateNotifier<int> {
  QuizXpNotifier(this._storage) : super(_storage.loadQuizXp());

  final LocalStorageService _storage;

  Future<void> addXp(int xp) async {
    state = state + xp;
    await _storage.saveQuizXp(state);
  }
}

final quizTotalXpProvider = StateNotifierProvider<QuizXpNotifier, int>((ref) {
  return QuizXpNotifier(ref.watch(storageServiceProvider));
});

