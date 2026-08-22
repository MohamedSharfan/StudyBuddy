import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studybuddy/src/features/gamification/application/gamification_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('completeLesson awards 1 coin and first note achievement', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Allow async hydrate to settle on empty state.
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final reward = container
        .read(gamificationControllerProvider.notifier)
        .completeLesson('photosynthesis');

    final state = container.read(gamificationControllerProvider);

    expect(reward.coinsAwarded, 1);
    expect(state.coins, 1);
    expect(state.completedLessons, contains('photosynthesis'));
    expect(
      state.achievements.singleWhere((item) => item.code == 'first_note').unlocked,
      isTrue,
    );
  });

  test('completeFlashcardReview awards 2 coins once per subject', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final controller = container.read(gamificationControllerProvider.notifier);
    final first = controller.completeFlashcardReview('science');
    final second = controller.completeFlashcardReview('science');

    final state = container.read(gamificationControllerProvider);

    expect(first.coinsAwarded, 2);
    expect(second.alreadyClaimed, isTrue);
    expect(state.coins, 2);
    expect(state.completedFlashcardSets, contains('science'));
    expect(
      state.achievements
          .singleWhere((item) => item.code == 'first_flashcards')
          .unlocked,
      isTrue,
    );
  });

  test('completeQuiz requires 80 percent to award coins', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final controller = container.read(gamificationControllerProvider.notifier);
    final failed = controller.completeQuiz(
      subjectId: 'science',
      correctAnswers: 2,
      totalQuestions: 4,
    );
    final passed = controller.completeQuiz(
      subjectId: 'science',
      correctAnswers: 4,
      totalQuestions: 4,
    );

    final state = container.read(gamificationControllerProvider);

    expect(failed.passed, isFalse);
    expect(passed.coinsAwarded, 5);
    expect(state.coins, 5);
    expect(state.completedQuizzes, contains('science'));
  });
}
