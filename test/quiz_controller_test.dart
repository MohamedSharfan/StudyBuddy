import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studybuddy/src/features/quiz/application/quiz_controller.dart';

void main() {
  test('answer records correctness and next advances question', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(quizControllerProvider.notifier);
    controller.answer(optionId: 'a', correctOptionId: 'a');

    var state = container.read(quizControllerProvider);
    expect(state.answered, isTrue);
    expect(state.correctAnswers, 1);

    controller.next(2);
    state = container.read(quizControllerProvider);
    expect(state.currentIndex, 1);
    expect(state.answered, isFalse);
    expect(state.selectedOptionId, isNull);
  });
}
