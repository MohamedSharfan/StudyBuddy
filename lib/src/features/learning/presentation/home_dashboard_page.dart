import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/animated_card.dart';
import '../../auth/application/auth_controller.dart';
import '../../gamification/application/gamification_controller.dart';
import '../application/learning_providers.dart';
import 'widgets/subject_icon.dart';
import '../../../shared/widgets/particle_background.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(authControllerProvider);
    final game = ref.watch(gamificationControllerProvider);
    final subjects = ref.watch(subjectsProvider);
    final featured = subjects.first;
    final pad = AppSpace.s(context, 16);

    return Scaffold(
      body: ParticleBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(pad, AppSpace.s(context, 10), pad, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top bar with panda logo, coins, and notifications
                      Row(
                        children: [
                          FloatingAnimation(
                            offset: 8,
                            duration: const Duration(seconds: 3),
                            child: PulseAnimation(
                              child: BrandLogo(
                                size: AppSpace.s(context, 48),
                                animated: false,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Coins display
                          AnimatedCard(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2D1B4E),
                                Color(0xFF1A0B2E),
                              ],
                            ),
                            elevation: 8,
                            borderRadius: 20,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PulseAnimation(
                                    minScale: 0.95,
                                    maxScale: 1.05,
                                    child: const Icon(
                                      Icons.toll_rounded,
                                      color: AppColors.goldenYellow,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${game.coins}',
                                    style: const TextStyle(
                                      color: AppColors.goldenYellow,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Notification icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D1B4E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpace.s(context, 16)),
                      // Welcome text
                      Text(
                        'Hey, ${student?.name.split(' ').first ?? 'Student'}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to learn something new?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                      ),
                      SizedBox(height: AppSpace.s(context, 20)),
                      // Featured card with magical book
                      FloatingAnimation(
                        offset: 10,
                        duration: const Duration(seconds: 4),
                        child: AnimatedCard(
                          gradient: AppColors.vibrantCardGradient,
                          elevation: 16,
                          borderRadius: 24,
                          onTap: () => context.push('/subjects/${featured.id}'),
                          child: Stack(
                            children: [
                              // Sparkles decoration
                              Positioned(
                                top: 20,
                                right: 20,
                                child: PulseAnimation(
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 40,
                                right: 60,
                                child: PulseAnimation(
                                  duration: const Duration(milliseconds: 1700),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 30,
                                right: 100,
                                child: PulseAnimation(
                                  duration: const Duration(milliseconds: 1900),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(AppSpace.s(context, 20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      featured.chapters.first.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        AnimatedCard(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF7B2CBF),
                                              Color(0xFF9D4EDD),
                                            ],
                                          ),
                                          elevation: 4,
                                          borderRadius: 16,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.menu_book_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'LEARN',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        AnimatedCard(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF7B2CBF),
                                              Color(0xFF9D4EDD),
                                            ],
                                          ),
                                          elevation: 4,
                                          borderRadius: 16,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.style_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'FLASHCARDS',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        AnimatedCard(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF7B2CBF),
                                              Color(0xFF9D4EDD),
                                            ],
                                          ),
                                          elevation: 4,
                                          borderRadius: 16,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.quiz_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'QUIZ',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        AnimatedCard(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF7B2CBF),
                                              Color(0xFF9D4EDD),
                                            ],
                                          ),
                                          elevation: 4,
                                          borderRadius: 16,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.smart_toy_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'AI PANDA',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpace.s(context, 20)),
                      // Continue Learning section
                      Row(
                        children: [
                          Text(
                            'Continue Learning',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                color: AppColors.vibrantPurple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AnimatedCard(
                        gradient: AppColors.darkCardGradient,
                        elevation: 8,
                        borderRadius: 20,
                        onTap: () => context.push('/subjects/${featured.id}'),
                        child: Padding(
                          padding: EdgeInsets.all(AppSpace.s(context, 16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                featured.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: featured.progress,
                                  minHeight: 8,
                                  backgroundColor: const Color(0xFF0D0221),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.vibrantPurple,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '${(featured.progress * 100).round()}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const Spacer(),
                                  AnimatedCard(
                                    gradient: AppColors.vibrantCardGradient,
                                    elevation: 4,
                                    borderRadius: 16,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: const Text(
                                        'Continue',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpace.s(context, 20)),
                      // Your Progress section
                      Text(
                        'Your Progress',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedCard(
                        gradient: AppColors.darkCardGradient,
                        elevation: 8,
                        borderRadius: 20,
                        child: Padding(
                          padding: EdgeInsets.all(AppSpace.s(context, 16)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Level ${15}',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: game.coins / 3000,
                                        minHeight: 8,
                                        backgroundColor: const Color(0xFF0D0221),
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF14B8A6),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'XP ${game.coins} / 3,000',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              FloatingAnimation(
                                offset: 6,
                                duration: const Duration(seconds: 3),
                                child: PulseAnimation(
                                  child: BrandLogo(
                                    size: 48,
                                    animated: false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  Text(
                                    student?.name.split(' ').first ?? 'Student',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Gold I',
                                    style: TextStyle(
                                      color: AppColors.goldenYellow,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpace.s(context, 12)),
                      // Streak section
                      AnimatedCard(
                        gradient: AppColors.darkCardGradient,
                        elevation: 8,
                        borderRadius: 20,
                        child: Padding(
                          padding: EdgeInsets.all(AppSpace.s(context, 16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${game.streakDays} Day Streak',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List.generate(7, (index) {
                                  final isActive = index < game.streakDays;
                                  return Column(
                                    children: [
                                      PulseAnimation(
                                        minScale: isActive ? 0.95 : 1.0,
                                        maxScale: isActive ? 1.05 : 1.0,
                                        child: Icon(
                                          Icons.local_fire_department_rounded,
                                          color: isActive
                                              ? AppColors.streakOrange
                                              : Colors.white.withValues(alpha: 0.2),
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.6),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpace.s(context, 12)),
                      // Panda motivational card
                      AnimatedCard(
                        gradient: AppColors.vibrantCardGradient,
                        elevation: 12,
                        borderRadius: 20,
                        child: Padding(
                          padding: EdgeInsets.all(AppSpace.s(context, 16)),
                          child: Row(
                            children: [
                              FloatingAnimation(
                                offset: 8,
                                duration: const Duration(seconds: 3),
                                child: PulseAnimation(
                                  child: BrandLogo(
                                    size: 56,
                                    animated: false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Keep learning!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "You're doing awesome! 🎵",
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PulseAnimation(
                                child: const Icon(
                                  Icons.emoji_events_rounded,
                                  color: AppColors.goldenYellow,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(pad, 0, pad, AppSpace.s(context, 20)),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subjects',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 12),
                      ...subjects.asMap().entries.map((entry) {
                        final index = entry.key;
                        final subject = entry.value;
                        final color = Color(subject.colorValue);
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FloatingAnimation(
                            offset: 4,
                            duration: Duration(milliseconds: 3000 + (index * 200)),
                            child: AnimatedCard(
                              gradient: AppColors.darkCardGradient,
                              elevation: 8,
                              borderRadius: 20,
                              onTap: () => context.push('/subjects/${subject.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    PulseAnimation(
                                      duration: Duration(milliseconds: 1500 + (index * 100)),
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              color,
                                              color.withValues(alpha: 0.7),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: color.withValues(alpha: 0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          subjectIcon(subject.icon),
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subject.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${subject.chapters.length} chapters • ${(subject.progress * 100).round()}% done',
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: LinearProgressIndicator(
                                              value: subject.progress,
                                              minHeight: 6,
                                              backgroundColor: const Color(0xFF0D0221),
                                              valueColor: AlwaysStoppedAnimation<Color>(color),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
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
