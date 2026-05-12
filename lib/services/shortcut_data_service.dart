import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/shortcut.dart';

class ShortcutDataService {
  const ShortcutDataService();

  Future<List<ShortcutItem>> loadFromAsset(
    String dataFile,
    String category,
  ) async {
    final jsonString = await rootBundle.loadString(dataFile);
    final List<dynamic> data = jsonDecode(jsonString) as List<dynamic>;
    return data
        .map((item) => ShortcutItem.fromJson(item as Map<String, dynamic>))
        .map(
          (item) => ShortcutItem(
            id: item.id,
            category: category,
            shortcut: item.shortcut,
            function: item.function,
            description: item.description,
          ),
        )
        .toList();
  }
}
