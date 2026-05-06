import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
import '../../widgets/shortcut_card.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Shortcuts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: PremiumSearchField(
              hintText: 'Search by shortcut, function, category',
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const EmptyState(
                    title: 'No results',
                    subtitle: 'Try searching for a different keyword.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return ShortcutCard(
                        item: item,
                        onTap: () => ref
                            .read(recentProvider.notifier)
                            .addRecent(item.id),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: results.length,
                  ),
          ),
        ],
      ),
    );
  }
}
