import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shortcut_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final allAsync = ref.watch(allShortcutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: () => ref.read(favoritesProvider.notifier).clear(),
          ),
        ],
      ),
      body: allAsync.when(
        data: (items) {
          final favoriteItems = items
              .where((item) => favorites.contains(item.id))
              .toList();

          if (favoriteItems.isEmpty) {
            return const EmptyState(
              title: 'No favorites yet',
              subtitle: 'Tap the heart on any shortcut to save it here.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemBuilder: (context, index) {
              final item = favoriteItems[index];
              return ShortcutCard(
                item: item,
                onTap: () =>
                    ref.read(recentProvider.notifier).addRecent(item.id),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: favoriteItems.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Unable to load favorites: $error')),
      ),
    );
  }
}
