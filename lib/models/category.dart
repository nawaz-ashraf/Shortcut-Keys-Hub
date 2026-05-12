import 'package:flutter/material.dart';

class ShortcutCategory {
  const ShortcutCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.dataFile,
    required this.accent,
    this.logoUrl,
  });

  final String id;
  final String title;
  final IconData icon;
  final String dataFile;
  final Color accent;
  final String? logoUrl;
}
