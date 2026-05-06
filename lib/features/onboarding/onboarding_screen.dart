import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../widgets/glass_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  final _pages = const [
    _OnboardingPage(
      title: 'Learn shortcuts faster',
      subtitle: 'Discover curated shortcuts for every productivity tool.',
      icon: Icons.school_rounded,
    ),
    _OnboardingPage(
      title: 'Increase productivity',
      subtitle: 'Save minutes every day with instant shortcut recall.',
      icon: Icons.bolt_rounded,
    ),
    _OnboardingPage(
      title: 'Save favorites',
      subtitle: 'Bookmark and revisit your most used shortcuts.',
      icon: Icons.favorite_rounded,
    ),
    _OnboardingPage(
      title: 'Master workflows',
      subtitle: 'Train with quiz mode and daily tips.',
      icon: Icons.auto_graph_rounded,
    ),
  ];

  Future<void> _finish() async {
    await ref.read(storageServiceProvider).setOnboardingComplete(true);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) => _pages[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: _finish, child: const Text('Skip')),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (dot) => AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _index == dot ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: _index == dot
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: _index == _pages.length - 1
                        ? _finish
                        : () => _pageController.nextPage(
                            duration: 400.ms,
                            curve: Curves.easeOut,
                          ),
                    child: Text(
                      _index == _pages.length - 1 ? 'Get Started' : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassCard(
            borderRadius: 32,
            padding: const EdgeInsets.all(24),
            child: Icon(
              icon,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2);
  }
}
