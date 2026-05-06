import 'package:flutter/material.dart';

import '../../models/category.dart';
import 'app_constants.dart';

class AppCategories {
  static const windows = ShortcutCategory(
    id: 'windows',
    title: 'Windows Shortcut Keys',
    icon: Icons.window_rounded,
    dataFile: AppConstants.dataWindows,
    accent: Color(0xFF4E8DFF),
  );

  static const mac = ShortcutCategory(
    id: 'macos',
    title: 'MacOS Shortcut Keys',
    icon: Icons.laptop_mac_rounded,
    dataFile: AppConstants.dataMac,
    accent: Color(0xFFB86BFF),
  );

  static const excel = ShortcutCategory(
    id: 'excel',
    title: 'MS Excel Shortcut Keys',
    icon: Icons.grid_view_rounded,
    dataFile: AppConstants.dataExcel,
    accent: Color(0xFF00C48C),
  );

  static const word = ShortcutCategory(
    id: 'word',
    title: 'MS Word Shortcut Keys',
    icon: Icons.description_rounded,
    dataFile: AppConstants.dataWord,
    accent: Color(0xFF3D7BFF),
  );

  static const powerpoint = ShortcutCategory(
    id: 'powerpoint',
    title: 'PowerPoint Shortcut Keys',
    icon: Icons.slideshow_rounded,
    dataFile: AppConstants.dataPowerPoint,
    accent: Color(0xFFFF8B3D),
  );

  static const tally = ShortcutCategory(
    id: 'tally',
    title: 'Tally Shortcut Keys',
    icon: Icons.account_balance_rounded,
    dataFile: AppConstants.dataTally,
    accent: Color(0xFF2EC4FF),
  );

  static const autocad = ShortcutCategory(
    id: 'autocad',
    title: 'AutoCAD Shortcut Keys',
    icon: Icons.architecture_rounded,
    dataFile: AppConstants.dataAutoCad,
    accent: Color(0xFFFF5C7A),
  );

  static const vscode = ShortcutCategory(
    id: 'vscode',
    title: 'VS Code Shortcut Keys',
    icon: Icons.code_rounded,
    dataFile: AppConstants.dataVsCode,
    accent: Color(0xFF00D1FF),
  );

  static const chrome = ShortcutCategory(
    id: 'chrome',
    title: 'Chrome Shortcut Keys',
    icon: Icons.public_rounded,
    dataFile: AppConstants.dataChrome,
    accent: Color(0xFFFFCC29),
  );

  static const photoshop = ShortcutCategory(
    id: 'photoshop',
    title: 'Photoshop Shortcut Keys',
    icon: Icons.brush_rounded,
    dataFile: AppConstants.dataPhotoshop,
    accent: Color(0xFF50C4FF),
  );

  static const all = [
    windows,
    mac,
    excel,
    word,
    powerpoint,
    tally,
    autocad,
    vscode,
    chrome,
    photoshop,
  ];
}
