import 'package:flutter/material.dart';

import '../../widgets/keycap.dart';

class KeyboardViewerScreen extends StatelessWidget {
  const KeyboardViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['Esc', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10'],
      ['~', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '='],
      ['Tab', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '[', ']'],
      ['Caps', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';', '\\'],
      ['Shift', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/'],
      ['Ctrl', 'Alt', 'Cmd', 'Space', 'Cmd', 'Alt', 'Ctrl'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Keyboard Viewer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: rows
              .map(
                (row) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: row.map((label) => KeyCap(label: label)).toList(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
