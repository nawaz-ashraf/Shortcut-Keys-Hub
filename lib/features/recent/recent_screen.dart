import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/premium_back_button.dart';
import '../../widgets/shortcut_card.dart';

class RecentScreen extends ConsumerWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentIds = ref.watch(recentProvider);
    final allAsync = ref.watch(allShortcutsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const PremiumBackButton(),
        leadingWidth: 60,
        title: const Text('Recently Viewed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: () => ref.read(recentProvider.notifier).clear(),
          ),
        ],
      ),
      body: allAsync.when(
        data: (items) {
          final byId = {for (final item in items) item.id: item};
          final recent = recentIds.map((id) => byId[id]).whereType().toList();

          if (recent.isEmpty) {
            return const EmptyState(
              title: 'No recent shortcuts',
              subtitle: 'Your recently opened shortcuts appear here.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemBuilder: (context, index) {
              final item = recent[index];
              return ShortcutCard(
                item: item,
                onTap: () =>
                    ref.read(recentProvider.notifier).addRecent(item.id),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: recent.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Unable to load recents: $error')),
      ),
    );
  }
}
