import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clay_card.dart';
import '../../../shared/widgets/learning_app_bar.dart';
import '../../../shared/widgets/particle_background.dart';
import '../application/gamification_controller.dart';

class RewardsPage extends ConsumerWidget {
  const RewardsPage({super.key});

  static const _rewards = [
    ('Scholar Panda Outfit', 'Equip a study look', 450, Icons.checkroom_rounded),
    ('Cool Violet Theme', 'Premium purple glow', 800, Icons.palette_rounded),
    ('Gold Profile Frame', 'Shine on the ranks', 650, Icons.crop_square_rounded),
    ('Exam Coach Stickers', 'Chat flair pack', 300, Icons.sticky_note_2_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gamificationControllerProvider);

    return Scaffold(
      appBar: const LearningAppBar(title: 'Reward shop'),
      body: ParticleBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gold, Color(0xFFF59E0B)],
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: .35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.toll_rounded,
                    size: 40,
                    color: Color(0xFF78350F),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${game.coins} coins',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF422006),
                              ),
                        ),
                        Text(
                          'Spend wisely — looks are forever cool.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF78350F),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            for (final reward in _rewards) ...[
              ClayCard(
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(reward.$4, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward.$1,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          Text(
                            reward.$2,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.toll_rounded,
                          color: AppColors.gold,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${reward.$3}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
