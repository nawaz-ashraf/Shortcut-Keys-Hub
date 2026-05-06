import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_categories.dart';
import '../../core/providers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
import '../../widgets/shortcut_card.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  String _query = '';
  final Set<String> _filters = {};

  @override
  Widget build(BuildContext context) {
    final category = AppCategories.all.firstWhere(
      (item) => item.id == widget.categoryId,
      orElse: () => AppCategories.all.first,
    );

    final shortcutsAsync = ref.watch(
      categoryShortcutsProvider(widget.categoryId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        actions: [
          IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
        ],
      ),
      body: shortcutsAsync.when(
        data: (items) {
          final filtered = items.where((item) {
            final matchesQuery =
                _query.isEmpty ||
                item.shortcut.toLowerCase().contains(_query) ||
                item.function.toLowerCase().contains(_query);

            final matchesFilters =
                _filters.isEmpty ||
                _filters.every(
                  (filter) => item.shortcut.toLowerCase().contains(filter),
                );

            return matchesQuery && matchesFilters;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: PremiumSearchField(
                  hintText: 'Search in ${category.title}',
                  onChanged: (value) => setState(() {
                    _query = value.trim().toLowerCase();
                  }),
                ),
              ),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final filter in ['ctrl', 'alt', 'shift', 'cmd', 'win'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter.toUpperCase()),
                          selected: _filters.contains(filter),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _filters.add(filter);
                              } else {
                                _filters.remove(filter);
                              }
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? const EmptyState(
                        title: 'No shortcuts found',
                        subtitle: 'Try a different search or filter',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return ShortcutCard(
                            item: item,
                            onTap: () => ref
                                .read(recentProvider.notifier)
                                .addRecent(item.id),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: filtered.length,
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Failed to load shortcuts: $error')),
      ),
    );
  }
}
