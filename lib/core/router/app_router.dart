import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../features/categories/category_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/keyboard_viewer/keyboard_viewer_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/quiz/quiz_category_screen.dart';
import '../../features/quiz/quiz_result_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/recent/recent_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../widgets/main_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final isOnboarded = storage.isOnboardingComplete();

  return GoRouter(
    initialLocation: isOnboarded ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _fadePage(state, const OnboardingScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/quiz',
                builder: (context, state) => const QuizCategoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      // ─── DETAIL / SUB-SCREENS ───────────────────────────────────────
      GoRoute(
        path: '/category/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'windows';
          return _slidePage(state, CategoryScreen(categoryId: id));
        },
      ),
      GoRoute(
        path: '/recent',
        pageBuilder: (context, state) =>
            _slidePage(state, const RecentScreen()),
      ),
      GoRoute(
        path: '/keyboard',
        pageBuilder: (context, state) =>
            _slidePage(state, const KeyboardViewerScreen()),
      ),
      // ─── QUIZ PLAY & RESULTS ────────────────────────────────────────
      GoRoute(
        path: '/quiz/play/:categoryId',
        pageBuilder: (context, state) {
          final categoryId = state.pathParameters['categoryId'] ?? 'all';
          return _slidePage(state, QuizScreen(categoryId: categoryId));
        },
      ),
      GoRoute(
        path: '/quiz/result',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _slidePage(
            state,
            QuizResultScreen(
              score: extra['score'] as int? ?? 0,
              correct: extra['correct'] as int? ?? 0,
              total: extra['total'] as int? ?? 1,
              categoryId: extra['categoryId'] as String? ?? 'all',
            ),
          );
        },
      ),
    ],
  );
});

/// Cupertino-style slide transition for detail screens.
CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideIn = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      final fadeIn = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );

      return SlideTransition(
        position: slideIn,
        child: FadeTransition(opacity: fadeIn, child: child),
      );
    },
  );
}

/// Simple fade transition for onboarding.
CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
