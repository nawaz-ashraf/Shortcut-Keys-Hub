import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../core/providers.dart';
import '../core/utils/haptics.dart';
import '../models/shortcut.dart';
import 'glass_card.dart';
import 'keycap.dart';

class ShortcutCard extends ConsumerWidget {
  const ShortcutCard({super.key, required this.item, this.onTap});

  final ShortcutItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(item.id);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        await AppHaptics.light();
        onTap?.call();
      },
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (int i = 0; i < item.keys.length; i++) ...[
                  KeyCap(label: item.keys[i]),
                  if (i != item.keys.length - 1)
                    Text('+', style: theme.textTheme.titleMedium),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.function,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await AppHaptics.light();
                    await ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(item.id);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? theme.colorScheme.primary
                        : theme.iconTheme.color?.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await AppHaptics.light();
                    await Clipboard.setData(
                      ClipboardData(
                        text: '${item.shortcut} — ${item.function}',
                      ),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_rounded),
                ),
                IconButton(
                  onPressed: () async {
                    await AppHaptics.light();
                    await Share.share(
                      '${item.shortcut} — ${item.function}',
                      subject: 'Shortcut from Shortcut Keys Hub',
                    );
                  },
                  icon: const Icon(Icons.share_rounded),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.15),
    );
  }
}
