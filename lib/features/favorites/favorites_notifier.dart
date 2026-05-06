import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/local_storage_service.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier(this._storage) : super(_storage.loadFavorites());

  final LocalStorageService _storage;

  bool isFavorite(String id) => state.contains(id);

  Future<void> toggleFavorite(String id) async {
    final updated = {...state};
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = updated;
    await _storage.saveFavorites(state);
  }

  Future<void> clear() async {
    state = {};
    await _storage.saveFavorites(state);
  }
}
