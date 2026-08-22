import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/progress_store.dart';
import '../../../core/persistence/supabase_sync.dart';
import '../../auth/application/auth_controller.dart';
import '../domain/achievement.dart';
import '../domain/gamification_state.dart';
import '../domain/reward_result.dart';

final gamificationControllerProvider =
    NotifierProvider<GamificationController, GamificationState>(
  GamificationController.new,
);

class GamificationController extends Notifier<GamificationState> {
  static const lessonCoins = 1;
  static const flashcardCoins = 2;
  static const quizCoins = 5;
  static const quizPassPercent = 80;

  String _userId = 'guest';
  var _ready = false;

  @override
  GamificationState build() {
    ref.listen(authControllerProvider, (prev, next) {
      final nextId = next?.id ?? 'guest';
      if (nextId != _userId) {
        _userId = nextId;
        Future.microtask(_hydrate);
      }
    });
    Future.microtask(_hydrate);
    return GamificationState.empty();
  }

  Future<void> _hydrate() async {
    final auth = ref.read(authControllerProvider);
    _userId = auth?.id ?? 'guest';

    final local = await ProgressStore.instance.load(_userId);
    if (local != null) {
      state = local;
    } else {
      state = GamificationState.empty();
    }

    final cloud = await SupabaseSync.loadProgress(_userId);
    if (cloud != null) {
      // Prefer richer of local vs cloud (max coins / union of completions).
      state = _merge(state, cloud);
      await ProgressStore.instance.save(_userId, state);
    }
    _ready = true;
  }

  GamificationState _merge(GamificationState a, GamificationState b) {
    final coins = a.coins >= b.coins ? a.coins : b.coins;
    return a.copyWith(
      coins: coins,
      streakDays: a.streakDays >= b.streakDays ? a.streakDays : b.streakDays,
      rank: _rankFor(coins),
      lifetimeEarned: a.lifetimeEarned >= b.lifetimeEarned
          ? a.lifetimeEarned
          : b.lifetimeEarned,
      lastActivityDay: a.lastActivityDay ?? b.lastActivityDay,
      completedLessons: {...a.completedLessons, ...b.completedLessons},
      completedQuizzes: {...a.completedQuizzes, ...b.completedQuizzes},
      completedFlashcardSets: {
        ...a.completedFlashcardSets,
        ...b.completedFlashcardSets,
      },
      achievements: [
        for (final item in a.achievements)
          Achievement(
            code: item.code,
            title: item.title,
            description: item.description,
            icon: item.icon,
            unlocked: item.unlocked ||
                b.achievements.any((x) => x.code == item.code && x.unlocked),
          ),
      ],
    );
  }

  Future<void> _persist() async {
    if (!_ready && state.coins == 0 && state.completedLessons.isEmpty) {
      // Still allow first write after hydrate settles.
    }
    await ProgressStore.instance.save(_userId, state);
    // Fire-and-forget cloud sync for signed-in users.
    unawaited(SupabaseSync.saveProgress(_userId, state));
  }

  RewardResult completeLesson(String lessonId) {
    if (state.completedLessons.contains(lessonId)) {
      return const RewardResult.none();
    }

    final completedLessons = {...state.completedLessons, lessonId};
    final result = _applyReward(
      coins: lessonCoins,
      title: 'Lesson Complete!',
      subtitle: 'You mined gold from your study session.',
      completedLessons: completedLessons,
    );
    unawaited(SupabaseSync.recordLesson(_userId, lessonId));
    return result;
  }

  RewardResult completeFlashcardReview(String subjectId) {
    if (state.completedFlashcardSets.contains(subjectId)) {
      return const RewardResult.none();
    }

    final completedFlashcardSets = {
      ...state.completedFlashcardSets,
      subjectId,
    };
    final result = _applyReward(
      coins: flashcardCoins,
      title: 'Flashcards Cleared!',
      subtitle: 'Memory boost unlocked. Keep flipping!',
      completedFlashcardSets: completedFlashcardSets,
    );
    unawaited(SupabaseSync.recordFlashcards(_userId, subjectId));
    return result;
  }

  RewardResult completeQuiz({
    required String subjectId,
    required int correctAnswers,
    required int totalQuestions,
  }) {
    if (state.completedQuizzes.contains(subjectId)) {
      return const RewardResult.none();
    }

    final percent = totalQuestions == 0
        ? 0
        : ((correctAnswers / totalQuestions) * 100).round();

    if (percent < quizPassPercent) {
      return RewardResult.failed(
        title: 'Not quite yet',
        subtitle:
            'You scored $percent%. Score $quizPassPercent% or higher to pass and earn +$quizCoins coins.',
      );
    }

    final completedQuizzes = {...state.completedQuizzes, subjectId};
    final result = _applyReward(
      coins: quizCoins,
      title: 'Quiz Conquered!',
      subtitle:
          '$correctAnswers / $totalQuestions correct ($percent%) — epic haul!',
      completedQuizzes: completedQuizzes,
    );
    unawaited(SupabaseSync.recordQuiz(_userId, subjectId, percent));
    return result;
  }

  RewardResult _applyReward({
    required int coins,
    required String title,
    required String subtitle,
    Set<String>? completedLessons,
    Set<String>? completedQuizzes,
    Set<String>? completedFlashcardSets,
  }) {
    final nextLessons = completedLessons ?? state.completedLessons;
    final nextQuizzes = completedQuizzes ?? state.completedQuizzes;
    final nextFlashcards =
        completedFlashcardSets ?? state.completedFlashcardSets;
    final nextCoins = state.coins + coins;
    final nextRank = _rankFor(nextCoins);
    final lifetime = state.lifetimeEarned + coins;
    final streakUpdate = _nextStreak();

    var nextAchievements = state.achievements;
    final unlockedNow = <Achievement>[];

    void tryUnlock(String code) {
      final before = nextAchievements;
      nextAchievements = _unlock(nextAchievements, code);
      if (!_isUnlocked(before, code) && _isUnlocked(nextAchievements, code)) {
        unlockedNow.add(
          nextAchievements.firstWhere((item) => item.code == code),
        );
      }
    }

    if (nextLessons.length == 1) tryUnlock('first_note');
    if (nextQuizzes.length == 1) tryUnlock('first_quiz');
    if (nextFlashcards.length == 1) tryUnlock('first_flashcards');
    if (nextLessons.length >= 5) tryUnlock('five_lessons');
    if (nextQuizzes.length >= 3) tryUnlock('three_quizzes');
    if (lifetime >= 20) tryUnlock('coin_miner');
    if (streakUpdate.streak >= 7) tryUnlock('seven_day_streak');
    if (nextRank == 'Gold' ||
        nextRank == 'Platinum' ||
        nextRank == 'Champion') {
      tryUnlock('gold_rank');
    }

    state = state.copyWith(
      coins: nextCoins,
      rank: nextRank,
      lifetimeEarned: lifetime,
      streakDays: streakUpdate.streak,
      lastActivityDay: streakUpdate.day,
      completedLessons: nextLessons,
      completedQuizzes: nextQuizzes,
      completedFlashcardSets: nextFlashcards,
      achievements: nextAchievements,
    );

    unawaited(_persist());

    return RewardResult(
      coinsAwarded: coins,
      title: title,
      subtitle: subtitle,
      newlyUnlocked: unlockedNow,
    );
  }

  ({int streak, String day}) _nextStreak() {
    final today = DateTime.now().toUtc();
    final day =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final last = state.lastActivityDay;
    if (last == day) {
      return (streak: state.streakDays == 0 ? 1 : state.streakDays, day: day);
    }
    if (last != null) {
      final prev = DateTime.tryParse(last);
      if (prev != null) {
        final yesterday = DateTime.utc(today.year, today.month, today.day)
            .subtract(const Duration(days: 1));
        final prevDay = DateTime.utc(prev.year, prev.month, prev.day);
        if (prevDay == yesterday) {
          return (streak: state.streakDays + 1, day: day);
        }
      }
    }
    return (streak: 1, day: day);
  }

  bool _isUnlocked(List<Achievement> achievements, String code) {
    return achievements.any((item) => item.code == code && item.unlocked);
  }

  List<Achievement> _unlock(List<Achievement> achievements, String code) {
    return [
      for (final achievement in achievements)
        achievement.code == code
            ? Achievement(
                code: achievement.code,
                title: achievement.title,
                description: achievement.description,
                icon: achievement.icon,
                unlocked: true,
              )
            : achievement,
    ];
  }

  String _rankFor(int coins) {
    if (coins >= 8000) return 'Champion';
    if (coins >= 5000) return 'Platinum';
    if (coins >= 2500) return 'Gold';
    if (coins >= 1000) return 'Silver';
    return 'Bronze';
  }
}

void unawaited(Future<void> future) {
  future.catchError((_) {});
}
