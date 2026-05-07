class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.category = '',
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String category;
}
