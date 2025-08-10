class Question {
  final String text;
  final List<AnswerOption> options;
  final int correctIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

class AnswerOption {
  final String label;
  final int score; 
  AnswerOption({required this.label, required this.score});
}
