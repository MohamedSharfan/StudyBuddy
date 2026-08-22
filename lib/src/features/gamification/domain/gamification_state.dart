import 'achievement.dart';

class GamificationState {
  const GamificationState({
    required this.coins,
    required this.streakDays,
    required this.rank,
    required this.completedLessons,
    required this.completedQuizzes,
    required this.completedFlashcardSets,
    required this.achievements,
    this.lifetimeEarned = 0,
    this.lastActivityDay,
  });

  /// Fresh account — no dummy coins/streak.
  factory GamificationState.empty() {
    return const GamificationState(
      coins: 0,
      streakDays: 0,
      rank: 'Bronze',
      lifetimeEarned: 0,
      completedLessons: {},
      completedQuizzes: {},
      completedFlashcardSets: {},
      achievements: [
        Achievement(
          code: 'first_note',
          title: 'First Lesson',
          description: 'Complete your first lesson note.',
          icon: 'menu_book',
          unlocked: false,
        ),
        Achievement(
          code: 'first_quiz',
          title: 'Quiz Rookie',
          description: 'Finish your first quiz.',
          icon: 'quiz',
          unlocked: false,
        ),
        Achievement(
          code: 'first_flashcards',
          title: 'Card Flipper',
          description: 'Complete a full flashcard set.',
          icon: 'style',
          unlocked: false,
        ),
        Achievement(
          code: 'five_lessons',
          title: 'Study Streak Hero',
          description: 'Complete 5 lessons.',
          icon: 'auto_stories',
          unlocked: false,
        ),
        Achievement(
          code: 'three_quizzes',
          title: 'Quiz Champion',
          description: 'Complete 3 quizzes.',
          icon: 'emoji_events',
          unlocked: false,
        ),
        Achievement(
          code: 'seven_day_streak',
          title: '7 Day Streak',
          description: 'Keep learning for seven active days.',
          icon: 'local_fire_department',
          unlocked: false,
        ),
        Achievement(
          code: 'gold_rank',
          title: 'Gold Rank',
          description: 'Reach Gold rank with your coin haul.',
          icon: 'workspace_premium',
          unlocked: false,
        ),
        Achievement(
          code: 'coin_miner',
          title: 'Coin Miner',
          description: 'Earn 20 coins from study activities.',
          icon: 'toll',
          unlocked: false,
        ),
      ],
    );
  }

  @Deprecated('Use GamificationState.empty()')
  factory GamificationState.initial() => GamificationState.empty();

  final int coins;
  final int streakDays;
  final String rank;
  final int lifetimeEarned;
  final String? lastActivityDay;
  final Set<String> completedLessons;
  final Set<String> completedQuizzes;
  final Set<String> completedFlashcardSets;
  final List<Achievement> achievements;

  int get unlockedAchievementCount =>
      achievements.where((item) => item.unlocked).length;

  GamificationState copyWith({
    int? coins,
    int? streakDays,
    String? rank,
    int? lifetimeEarned,
    String? lastActivityDay,
    Set<String>? completedLessons,
    Set<String>? completedQuizzes,
    Set<String>? completedFlashcardSets,
    List<Achievement>? achievements,
  }) {
    return GamificationState(
      coins: coins ?? this.coins,
      streakDays: streakDays ?? this.streakDays,
      rank: rank ?? this.rank,
      lifetimeEarned: lifetimeEarned ?? this.lifetimeEarned,
      lastActivityDay: lastActivityDay ?? this.lastActivityDay,
      completedLessons: completedLessons ?? this.completedLessons,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      completedFlashcardSets:
          completedFlashcardSets ?? this.completedFlashcardSets,
      achievements: achievements ?? this.achievements,
    );
  }
}
