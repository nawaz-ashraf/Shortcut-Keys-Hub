import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_categories.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers.dart';
import '../../core/utils/haptics.dart';
import '../../models/quiz_question.dart';
import '../../models/shortcut.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/premium_back_button.dart';

/// The quiz gameplay screen with timer, XP, and animated feedback.
///
/// Accepts a [categoryId] — either a specific category or "all" for mixed.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with TickerProviderStateMixin {
  final _random = Random();
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _correctCount = 0;
  int _streak = 0;
  int? _selectedIndex;
  bool _isReady = false;

  // Timer
  Timer? _timer;
  int _timeRemaining = AppConstants.quizTimerSeconds;

  // Animations
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _generateQuestions(List<ShortcutItem> items) {
    final pool = items.toList();
    pool.shuffle(_random);
    _questions = pool.take(AppConstants.quizQuestionCount).map((item) {
      final options = <String>[item.shortcut];
      final otherItems = pool.where((p) => p.shortcut != item.shortcut).toList();
      otherItems.shuffle(_random);
      for (final other in otherItems) {
        if (options.length >= 4) break;
        if (!options.contains(other.shortcut)) {
          options.add(other.shortcut);
        }
      }
      // Fill if not enough unique options
      while (options.length < 4) {
        options.add('N/A');
      }
      options.shuffle(_random);
      return QuizQuestion(
        question: 'Which shortcut does: ${item.function}?',
        options: options,
        correctIndex: options.indexOf(item.shortcut),
        category: item.category,
      );
    }).toList();
    _isReady = true;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeRemaining = AppConstants.quizTimerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _timeRemaining--;
        if (_timeRemaining <= 0) {
          timer.cancel();
          _autoSkip();
        }
      });
    });
  }

  void _autoSkip() {
    if (_selectedIndex != null) return;
    setState(() {
      _selectedIndex = -1; // No selection — timeout
      _streak = 0;
    });
    _shakeController.forward().then((_) => _shakeController.reset());
  }

  void _selectAnswer(int index) async {
    if (_selectedIndex != null) return;
    _timer?.cancel();
    await AppHaptics.light();

    final isCorrect = index == _questions[_currentIndex].correctIndex;
    setState(() {
      _selectedIndex = index;
      if (isCorrect) {
        _correctCount++;
        _streak++;
        // Base 10 XP + speed bonus (up to 5 XP)
        final speedBonus =
            (_timeRemaining / AppConstants.quizTimerSeconds * AppConstants.quizSpeedBonusXp)
                .round();
        final streakBonus = _streak >= 3 ? 5 : 0;
        _score += AppConstants.quizCorrectXp + speedBonus + streakBonus;
        _glowController.forward().then((_) => _glowController.reset());
      } else {
        _streak = 0;
        _shakeController.forward().then((_) => _shakeController.reset());
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
      });
      _startTimer();
    } else {
      // Quiz complete — navigate to results
      _timer?.cancel();
      // Save XP
      ref.read(quizTotalXpProvider.notifier).addXp(_score);
      context.pushReplacement(
        '/quiz/result',
        extra: {
          'score': _score,
          'correct': _correctCount,
          'total': _questions.length,
          'categoryId': widget.categoryId,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine which shortcuts to load
    final AsyncValue<List<ShortcutItem>> shortcutsAsync;
    if (widget.categoryId == 'all') {
      shortcutsAsync = ref.watch(allShortcutsProvider);
    } else {
      shortcutsAsync = ref.watch(categoryShortcutsProvider(widget.categoryId));
    }

    // Get category name for title
    String title = 'Mixed Quiz';
    if (widget.categoryId != 'all') {
      final cat = AppCategories.all.firstWhere(
        (c) => c.id == widget.categoryId,
        orElse: () => AppCategories.all.first,
      );
      title = cat.title.replaceAll(' Shortcut Keys', '') + ' Quiz';
    }

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: const PremiumBackButton(),
          leadingWidth: 60,
          title: Text(title),
          actions: [
            // Streak indicator
            if (_streak >= 2)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.orange.withOpacity(0.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      '$_streak',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate().scale(begin: const Offset(0.5, 0.5), duration: 300.ms),
            // XP counter
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppConstants.darkAccent.withOpacity(0.3),
                    AppConstants.darkAccentSecondary.withOpacity(0.2),
                  ],
                ),
              ),
              child: Text(
                '$_score XP',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: shortcutsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const EmptyState(
                title: 'No shortcuts available',
                subtitle: 'Load shortcut data to start the quiz.',
              );
            }

            if (!_isReady) {
              _generateQuestions(items);
            }

            if (_questions.isEmpty) {
              return const EmptyState(
                title: 'Not enough data',
                subtitle: 'Need more shortcuts to generate quiz.',
              );
            }

            final question = _questions[_currentIndex];
            final progress = (_currentIndex + 1) / _questions.length;
            final timerProgress = _timeRemaining / AppConstants.quizTimerSeconds;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar + question counter
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.08),
                            valueColor: AlwaysStoppedAnimation(
                              AppConstants.darkAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_currentIndex + 1}/${_questions.length}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Timer ring
                  Center(
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: timerProgress,
                            strokeWidth: 4,
                            backgroundColor: isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.08),
                            valueColor: AlwaysStoppedAnimation(
                              _timeRemaining <= 5
                                  ? Colors.red
                                  : AppConstants.darkAccentSecondary,
                            ),
                          ),
                          Text(
                            '$_timeRemaining',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _timeRemaining <= 5 ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Question
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _shakeController.isAnimating
                              ? sin(_shakeAnimation.value * pi * 3) * 6
                              : 0,
                          0,
                        ),
                        child: child,
                      );
                    },
                    child: Text(
                      question.question,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Options
                  ...List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    final isSelected = index == _selectedIndex;
                    final isCorrect = index == question.correctIndex;
                    final hasAnswered = _selectedIndex != null;

                    Color? bgColor;
                    Color? borderColor;
                    if (hasAnswered) {
                      if (isCorrect) {
                        bgColor = Colors.green.withOpacity(0.15);
                        borderColor = Colors.green;
                      } else if (isSelected && !isCorrect) {
                        bgColor = Colors.red.withOpacity(0.15);
                        borderColor = Colors.red;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _selectAnswer(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: bgColor ??
                                (isDark
                                    ? const Color(0xFF1E2128)
                                    : const Color(0xFFE8ECF4)),
                            border: Border.all(
                              color: borderColor ??
                                  (isDark
                                      ? Colors.white.withOpacity(0.08)
                                      : Colors.black.withOpacity(0.06)),
                              width: borderColor != null ? 2 : 1,
                            ),
                            boxShadow: [
                              if (!hasAnswered)
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: borderColor?.withOpacity(0.2) ??
                                      AppConstants.darkAccent.withOpacity(0.1),
                                ),
                                child: Center(
                                  child: hasAnswered && isCorrect
                                      ? const Icon(Icons.check, color: Colors.green, size: 18)
                                      : hasAnswered && isSelected && !isCorrect
                                          ? const Icon(Icons.close, color: Colors.red, size: 18)
                                          : Text(
                                              String.fromCharCode(65 + index),
                                              style: theme.textTheme.labelLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  option,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                          delay: Duration(milliseconds: 80 * index),
                          duration: 300.ms,
                        );
                  }),

                  const Spacer(),

                  // Next button
                  if (_selectedIndex != null)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: _nextQuestion,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppConstants.darkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentIndex == _questions.length - 1
                              ? 'See Results'
                              : 'Next Question',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Unable to start quiz: $error')),
        ),
      ),
    );
  }
}
