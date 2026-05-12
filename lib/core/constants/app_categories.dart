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
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/windows.svg',
  );

  static const mac = ShortcutCategory(
    id: 'macos',
    title: 'MacOS Shortcut Keys',
    icon: Icons.laptop_mac_rounded,
    dataFile: AppConstants.dataMac,
    accent: Color(0xFFB86BFF),
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/apple.svg',
  );

  static const excel = ShortcutCategory(
    id: 'excel',
    title: 'MS Excel Shortcut Keys',
    icon: Icons.grid_view_rounded,
    dataFile: AppConstants.dataExcel,
    accent: Color(0xFF00C48C),
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/microsoftexcel.svg',
  );

  static const word = ShortcutCategory(
    id: 'word',
    title: 'MS Word Shortcut Keys',
    icon: Icons.description_rounded,
    dataFile: AppConstants.dataWord,
    accent: Color(0xFF3D7BFF),
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/microsoftword.svg',
  );

  static const powerpoint = ShortcutCategory(
    id: 'powerpoint',
    title: 'PowerPoint Shortcut Keys',
    icon: Icons.slideshow_rounded,
    dataFile: AppConstants.dataPowerPoint,
    accent: Color(0xFFFF8B3D),
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/microsoftpowerpoint.svg',
  );

  static const tally = ShortcutCategory(
    id: 'tally',
    title: 'Tally Shortcut Keys',
    icon: Icons.account_balance_rounded,
    dataFile: AppConstants.dataTally,
    accent: Color(0xFF2EC4FF),
    // Tally has no Simple Icons entry; fallback to icon
  );

  static const autocad = ShortcutCategory(
    id: 'autocad',
    title: 'AutoCAD Shortcut Keys',
    icon: Icons.architecture_rounded,
    dataFile: AppConstants.dataAutoCad,
    accent: Color(0xFFFF5C7A),
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/autocad.svg',
  );

  static const vscode = ShortcutCategory(
    id: 'vscode',
    title: 'VS Code Shortcut Keys',
    icon: Icons.code_rounded,
    dataFile: AppConstants.dataVsCode,
    accent: Color(0xFF00D1FF),
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/visualstudiocode.svg',
  );

  static const chrome = ShortcutCategory(
    id: 'chrome',
    title: 'Chrome Shortcut Keys',
    icon: Icons.public_rounded,
    dataFile: AppConstants.dataChrome,
    accent: Color(0xFFFFCC29),
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/googlechrome.svg',
  );

  static const photoshop = ShortcutCategory(
    id: 'photoshop',
    title: 'Photoshop Shortcut Keys',
    icon: Icons.brush_rounded,
    dataFile: AppConstants.dataPhotoshop,
    accent: Color(0xFF50C4FF),
    logoUrl: 'https://cdn.jsdelivr.net/npm/simple-icons@v13/icons/adobephotoshop.svg',
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
