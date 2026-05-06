import 'package:flutter/material.dart';

import 'glass_card.dart';

class PremiumSearchField extends StatelessWidget {
  const PremiumSearchField({
    super.key,
    required this.onChanged,
    this.hintText = 'Search shortcuts...',
    this.controller,
  });

  final ValueChanged<String> onChanged;
  final String hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}
