enum QuizQuestionType {
  multipleChoice,
  trueFalse,
  shortAnswer,
  essay,
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.type,
    this.options = const [],
    this.correctOptionId,
    this.correctAnswer,
    required this.explanation,
  });

  final String id;
  final String prompt;
  final QuizQuestionType type;
  final List<QuizOption> options;
  final String? correctOptionId; // For MCQ and True/False
  final String? correctAnswer; // For short answer (if provided)
  final String explanation;

  // Helper getters
  bool get isMultipleChoice => type == QuizQuestionType.multipleChoice;
  bool get isTrueFalse => type == QuizQuestionType.trueFalse;
  bool get isShortAnswer => type == QuizQuestionType.shortAnswer;
  bool get isEssay => type == QuizQuestionType.essay;
}

class QuizOption {
  const QuizOption({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}
