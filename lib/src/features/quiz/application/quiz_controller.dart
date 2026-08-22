import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizSessionState {
  const QuizSessionState({
    this.currentIndex = 0,
    this.selectedOptionId,
    this.correctAnswers = 0,
    this.answered = false,
    this.finished = false,
  });

  final int currentIndex;
  final String? selectedOptionId;
  final int correctAnswers;
  final bool answered;
  final bool finished;

  QuizSessionState copyWith({
    int? currentIndex,
    String? selectedOptionId,
    int? correctAnswers,
    bool? answered,
    bool? finished,
    bool clearSelection = false,
  }) {
    return QuizSessionState(
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionId:
          clearSelection ? null : selectedOptionId ?? this.selectedOptionId,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      answered: answered ?? this.answered,
      finished: finished ?? this.finished,
    );
  }
}

final quizControllerProvider =
    AutoDisposeNotifierProvider<QuizController, QuizSessionState>(
  QuizController.new,
);

class QuizController extends AutoDisposeNotifier<QuizSessionState> {
  @override
  QuizSessionState build() => const QuizSessionState();

  void answer({
    required String optionId,
    required String correctOptionId,
  }) {
    if (state.answered) {
      return;
    }

    state = state.copyWith(
      selectedOptionId: optionId,
      correctAnswers:
          optionId == correctOptionId ? state.correctAnswers + 1 : null,
      answered: true,
    );
  }

  void next(int questionCount) {
    if (state.currentIndex >= questionCount - 1) {
      state = state.copyWith(finished: true);
      return;
    }

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      answered: false,
      clearSelection: true,
    );
  }

  void restart() {
    state = const QuizSessionState();
  }
}
