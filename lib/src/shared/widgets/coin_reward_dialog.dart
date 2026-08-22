import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/gamification/domain/achievement.dart';
import '../../features/gamification/domain/reward_result.dart';

Future<void> showCoinRewardDialog(
  BuildContext context,
  RewardResult reward,
) async {
  if (!reward.hasReward) {
    return;
  }

  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Coin reward',
    barrierColor: Colors.black.withValues(alpha: .72),
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (context, animation, secondaryAnimation) {
      return CoinRewardDialog(reward: reward);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: .72, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class CoinRewardDialog extends StatefulWidget {
  const CoinRewardDialog({required this.reward, super.key});

  final RewardResult reward;

  @override
  State<CoinRewardDialog> createState() => _CoinRewardDialogState();
}

class _CoinRewardDialogState extends State<CoinRewardDialog>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _spinController;
  late final AnimationController _burstController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reward = widget.reward;
    final coinLabel =
        reward.coinsAwarded == 1 ? '1 COIN' : '${reward.coinsAwarded} COINS';

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: math.min(MediaQuery.sizeOf(context).width - 48, 360),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2A1060),
                Color(0xFF4C1D95),
                Color(0xFF6D28D9),
              ],
            ),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: .55),
              width: 1.6,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: .35),
                blurRadius: 40,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.coolViolet.withValues(alpha: .45),
                blurRadius: 48,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _burstController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(150, 150),
                          painter: _SparkBurstPainter(
                            progress: _burstController.value,
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _pulseController,
                        _spinController,
                      ]),
                      builder: (context, child) {
                        final pulse =
                            1 + (_pulseController.value * .08);
                        return Transform.scale(
                          scale: pulse,
                          child: Transform.rotate(
                            angle: _spinController.value * math.pi * 2,
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  colors: [
                                    Color(0xFFFFF7D6),
                                    AppColors.gold,
                                    Color(0xFFD97706),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.gold
                                        .withValues(alpha: .65),
                                    blurRadius: 28,
                                    spreadRadius: 4,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: .7),
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.monetization_on_rounded,
                                color: Color(0xFF92400E),
                                size: 54,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Text(
                'GOLD MINE!',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.4,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                reward.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'You got $coinLabel',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                reward.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.4,
                    ),
              ),
              if (reward.newlyUnlocked.isNotEmpty) ...[
                const SizedBox(height: 16),
                ...reward.newlyUnlocked.map(_AchievementChip.new),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: const Color(0xFF422006),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Collect',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  const _AchievementChip(this.achievement);

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: .4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded, color: AppColors.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievement unlocked',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SparkBurstPainter extends CustomPainter {
  _SparkBurstPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 12; i++) {
      final angle = (i / 12) * math.pi * 2;
      final distance = 28 + (progress * 48);
      final opacity = (1 - progress).clamp(0.0, 1.0);
      paint.color = [
        AppColors.gold,
        Colors.white,
        AppColors.neonCyan,
      ][i % 3]
          .withValues(alpha: opacity * .9);

      final point = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      canvas.drawCircle(point, 3.5 + (1 - progress) * 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
