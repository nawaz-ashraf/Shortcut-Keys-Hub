import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../models/quiz_question.dart';
import '../../models/shortcut.dart';
import '../../widgets/empty_state.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final _random = Random();
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;

  void _generateQuestions(List<ShortcutItem> items) {
    final pool = items.toList();
    pool.shuffle(_random);
    _questions = pool.take(10).map((item) {
      final options = <String>[item.shortcut];
      while (options.length < 4 && pool.isNotEmpty) {
        final candidate = pool[_random.nextInt(pool.length)].shortcut;
        if (!options.contains(candidate)) {
          options.add(candidate);
        }
      }
      options.shuffle(_random);
      return QuizQuestion(
        question: 'Which shortcut does: ${item.function}?',
        options: options,
        correctIndex: options.indexOf(item.shortcut),
      );
    }).toList();
  }

  void _selectAnswer(int index) {
    if (_selectedIndex != null) return;
    setState(() {
      _selectedIndex = index;
      if (index == _questions[_currentIndex].correctIndex) {
        _score += 10;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex += 1;
        _selectedIndex = null;
      });
    } else {
      setState(() {
        _currentIndex = 0;
        _selectedIndex = null;
        _score = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(allShortcutsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Mode')),
      body: allAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              title: 'No shortcuts available',
              subtitle: 'Load shortcut data to start the quiz.',
            );
          }

          if (_questions.isEmpty) {
            _generateQuestions(items);
          }

          final question = _questions[_currentIndex];
          final progress = (_currentIndex + 1) / _questions.length;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${_currentIndex + 1}/${_questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 16),
                Text(
                  question.question,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(question.options.length, (index) {
                  final option = question.options[index];
                  final isSelected = index == _selectedIndex;
                  final isCorrect = index == question.correctIndex;
                  final color = _selectedIndex == null
                      ? null
                      : (isCorrect ? Colors.green : Colors.red);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        backgroundColor: color,
                      ),
                      onPressed: () => _selectAnswer(index),
                      child: Text(option),
                    ).animate().fadeIn(duration: 300.ms),
                  );
                }),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Score: $_score XP'),
                    FilledButton(
                      onPressed: _selectedIndex == null ? null : _nextQuestion,
                      child: Text(
                        _currentIndex == _questions.length - 1
                            ? 'Restart'
                            : 'Next',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Unable to start quiz: $error')),
      ),
    );
  }
}
