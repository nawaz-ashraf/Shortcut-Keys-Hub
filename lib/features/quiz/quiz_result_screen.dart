import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers.dart';
import '../../services/ad_service.dart';
import '../../widgets/premium_back_button.dart';

/// Quiz results screen showing score, stars, and XP breakdown.
class QuizResultScreen extends ConsumerStatefulWidget {
  const QuizResultScreen({
    super.key,
    required this.score,
    required this.correct,
    required this.total,
    required this.categoryId,
  });

  final int score;
  final int correct;
  final int total;
  final String categoryId;

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  bool _shownInterstitial = false;

  @override
  void initState() {
    super.initState();
    // Show interstitial ad after quiz completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_shownInterstitial) {
        _shownInterstitial = true;
        AdService.instance.showInterstitialAd();
      }
    });
  }

  int get _stars {
    final percent = widget.correct / widget.total;
    if (percent >= 0.9) return 3;
    if (percent >= 0.6) return 2;
    if (percent >= 0.3) return 1;
    return 0;
  }

  String get _message {
    switch (_stars) {
      case 3:
        return 'Outstanding! You\'re a master! 🏆';
      case 2:
        return 'Great job! Keep practicing! 🌟';
      case 1:
        return 'Good start! Room to improve! 💪';
      default:
        return 'Don\'t give up! Try again! 🔄';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final percent = widget.correct / widget.total;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) context.go('/quiz');
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    PremiumBackButton(onPressed: () => context.go('/quiz')),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Share.share(
                          'I scored ${widget.score} XP (${widget.correct}/${widget.total}) in Shortcut Keys Hub Quiz! 🎯',
                          subject: 'My Quiz Score',
                        );
                      },
                      icon: const Icon(Icons.share_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Score circle
                SizedBox(
                  width: 180,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: percent),
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 12,
                              strokeCap: StrokeCap.round,
                              backgroundColor: isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.06),
                              valueColor: AlwaysStoppedAnimation(
                                _stars >= 2
                                    ? AppConstants.darkAccent
                                    : _stars == 1
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: widget.score),
                            duration: const Duration(milliseconds: 1200),
                            builder: (context, value, _) {
                              return Text(
                                '$value',
                                style: theme.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          Text(
                            'XP',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppConstants.darkAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 24),

                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final filled = i < _stars;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        filled ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 40,
                        color: filled ? Colors.amber : Colors.grey.withOpacity(0.3),
                      ),
                    )
                        .animate()
                        .scale(
                          delay: Duration(milliseconds: 800 + i * 200),
                          begin: const Offset(0, 0),
                          duration: 400.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn();
                  }),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  _message,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

                const SizedBox(height: 12),

                // Stats
                Text(
                  '${widget.correct} of ${widget.total} correct',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                  ),
                ).animate().fadeIn(delay: 800.ms),

                const Spacer(),

                // Bonus XP via rewarded ad
                if (AdService.instance.isRewardedAdReady)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        AdService.instance.showRewardedAd(
                          onRewarded: () {
                            ref.read(quizTotalXpProvider.notifier).addXp(20);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🎁 +20 Bonus XP earned!'),
                                ),
                              );
                            }
                          },
                        );
                      },
                      icon: const Icon(Icons.play_circle_outline_rounded),
                      label: const Text('Watch Ad for +20 Bonus XP'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 1000.ms),

                // Action buttons
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: () => context.pushReplacement(
                      '/quiz/play/${widget.categoryId}',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppConstants.darkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Play Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.2),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => context.go('/quiz'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Choose Another Category',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ).animate().fadeIn(delay: 1100.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
