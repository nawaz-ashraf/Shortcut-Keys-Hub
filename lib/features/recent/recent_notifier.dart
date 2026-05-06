import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../services/local_storage_service.dart';

class RecentNotifier extends StateNotifier<List<String>> {
  RecentNotifier(this._storage) : super(_storage.loadRecent());

  final LocalStorageService _storage;

  Future<void> addRecent(String id) async {
    final updated = [id, ...state.where((item) => item != id)];
    if (updated.length > AppConstants.recentLimit) {
      updated.removeRange(AppConstants.recentLimit, updated.length);
    }
    state = updated;
    await _storage.saveRecent(state);
  }

  Future<void> clear() async {
    state = [];
    await _storage.saveRecent(state);
  }
}
