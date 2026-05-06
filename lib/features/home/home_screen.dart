import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_categories.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers.dart';
import '../../models/shortcut.dart';
import '../../widgets/category_card.dart';
import '../../widgets/search_field.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shortcut_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortcutsAsync = ref.watch(allShortcutsProvider);
    final favorites = ref.watch(favoritesProvider);
    final recentIds = ref.watch(recentProvider);

    final data = shortcutsAsync.value ?? <ShortcutItem>[];
    final byId = {for (final item in data) item.id: item};
    final popular = data.take(6).toList();
    final recent = recentIds.map((id) => byId[id]).whereType<ShortcutItem>();
    final favoriteItems = favorites
        .map((id) => byId[id])
        .whereType<ShortcutItem>()
        .toList();

    final now = DateTime.now();
    final tip = AppConstants.dailyTips[now.day % AppConstants.dailyTips.length];

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(allShortcutsProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.7),
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Shortcut Keys Hub',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppConstants.darkAccent,
                                  AppConstants.darkAccentSecondary,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.darkAccent.withOpacity(
                                    0.4,
                                  ),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.bolt_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PremiumSearchField(
                        onChanged: (value) {
                          ref.read(searchQueryProvider.notifier).state = value;
                          context.go('/search');
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              AppConstants.darkAccent.withOpacity(0.2),
                              AppConstants.darkAccentSecondary.withOpacity(
                                0.15,
                              ),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Categories',
                    action: TextButton(
                      onPressed: () => context.go('/search'),
                      child: const Text('Explore'),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final category = AppCategories.all[index];
                    final count = data
                        .where((item) => item.category == category.id)
                        .length;
                    return CategoryCard(
                      category: category,
                      count: count,
                      onTap: () => context.go('/category/${category.id}'),
                    );
                  }, childCount: AppCategories.all.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Popular Shortcuts',
                    action: TextButton(
                      onPressed: () => context.go('/search'),
                      child: const Text('View all'),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = popular[index];
                      return SizedBox(
                        width: 260,
                        child: ShortcutCard(
                          item: item,
                          onTap: () => ref
                              .read(recentProvider.notifier)
                              .addRecent(item.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: popular.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Recently Viewed',
                    action: TextButton(
                      onPressed: () => context.go('/recent'),
                      child: const Text('Open'),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = recent.elementAt(index);
                      return SizedBox(
                        width: 260,
                        child: ShortcutCard(
                          item: item,
                          onTap: () => ref
                              .read(recentProvider.notifier)
                              .addRecent(item.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: recent.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Favorites',
                    action: TextButton(
                      onPressed: () => context.go('/favorites'),
                      child: const Text('Manage'),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = favoriteItems[index];
                      return SizedBox(
                        width: 260,
                        child: ShortcutCard(
                          item: item,
                          onTap: () => ref
                              .read(recentProvider.notifier)
                              .addRecent(item.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: favoriteItems.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
