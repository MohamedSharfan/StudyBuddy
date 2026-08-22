import 'achievement.dart';

class RewardResult {
  const RewardResult({
    required this.coinsAwarded,
    required this.title,
    required this.subtitle,
    this.newlyUnlocked = const [],
    this.alreadyClaimed = false,
    this.passed = true,
  });

  const RewardResult.none()
      : coinsAwarded = 0,
        title = '',
        subtitle = '',
        newlyUnlocked = const [],
        alreadyClaimed = true,
        passed = true;

  const RewardResult.failed({
    required this.title,
    required this.subtitle,
  })  : coinsAwarded = 0,
        newlyUnlocked = const [],
        alreadyClaimed = false,
        passed = false;

  final int coinsAwarded;
  final String title;
  final String subtitle;
  final List<Achievement> newlyUnlocked;
  final bool alreadyClaimed;
  final bool passed;

  bool get hasReward => passed && !alreadyClaimed && coinsAwarded > 0;
}
