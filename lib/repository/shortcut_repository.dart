import '../core/constants/app_categories.dart';
import '../models/shortcut.dart';
import '../services/shortcut_data_service.dart';

class ShortcutRepository {
  ShortcutRepository(this.dataService);

  final ShortcutDataService dataService;
  final Map<String, List<ShortcutItem>> _cache = {};

  Future<List<ShortcutItem>> loadAll() async {
    if (_cache.isNotEmpty) {
      return _cache.values.expand((list) => list).toList();
    }

    for (final category in AppCategories.all) {
      final items = await dataService.loadFromAsset(
        category.dataFile,
        category.id,
      );
      _cache[category.id] = items;
    }

    return _cache.values.expand((list) => list).toList();
  }

  Future<List<ShortcutItem>> loadCategory(String categoryId) async {
    if (_cache.containsKey(categoryId)) {
      return _cache[categoryId]!;
    }

    final category = AppCategories.all.firstWhere(
      (item) => item.id == categoryId,
      orElse: () => AppCategories.all.first,
    );

    final items = await dataService.loadFromAsset(
      category.dataFile,
      category.id,
    );
    _cache[categoryId] = items;
    return items;
  }
}
