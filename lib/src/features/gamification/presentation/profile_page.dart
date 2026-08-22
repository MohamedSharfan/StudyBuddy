import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/animated_entrance.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/clay_card.dart';
import '../../../shared/widgets/game_badge.dart';
import '../../../shared/widgets/metric_pill.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/animated_card.dart';
import '../../../shared/widgets/particle_background.dart';
import '../../auth/application/auth_controller.dart';
import '../../social/application/social_controller.dart';
import '../../social/presentation/share_profile_sheet.dart';
import '../application/gamification_controller.dart';
import '../domain/achievement.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(authControllerProvider);
    final network = ref.watch(socialControllerProvider);
    final social = ref.read(socialControllerProvider.notifier);
    final me = network.me;
    final game = ref.watch(gamificationControllerProvider);
    final unlocked = game.unlockedAchievementCount;
    final total = game.achievements.length;
    final lessonsDone = game.completedLessons.length;
    final quizzesDone = game.completedQuizzes.length;
    final flashDone = game.completedFlashcardSets.length;
    final pad = AppSpace.s(context, 16);
    final connections = social.myConnections();
    final incoming = social.incomingRequests();
    final national = me == null ? 0 : social.nationalRankOf(me.id);
    final provincial =
        me == null ? 0 : social.provinceRankOf(me.id, me.province);

    return Scaffold(
      body: ParticleBackground(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(pad, 8, pad, 24),
            children: [
              FloatingAnimation(
                offset: 5,
                duration: const Duration(seconds: 3),
                child: Row(
                  children: [
                    PulseAnimation(
                      child: BrandLogo(size: AppSpace.s(context, 34), animated: false),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const Spacer(),
                    if (me != null) ...[
                      IconButton(
                        tooltip: 'Share',
                        onPressed: () =>
                            showShareProfileSheet(context, student: me),
                        icon: const Icon(Icons.qr_code_2_rounded),
                      ),
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: () => context.push(AppRoutes.profileEdit),
                        icon: const Icon(Icons.edit_rounded),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                me == null
                    ? 'Claim a username to join Sri Lanka rankings & connections.'
                    : 'Your public StudyBuddy card — searchable like LinkedIn.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: .7),
                    ),
              ),
              if (me == null) ...[
                SizedBox(height: AppSpace.s(context, 12)),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.onboarding),
                  child: const Text('Set up username & province'),
                ),
              ],
              SizedBox(height: AppSpace.s(context, 12)),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 60),
                child: Container(
                  padding: EdgeInsets.all(AppSpace.s(context, 14)),
                  decoration: BoxDecoration(
                    gradient: AppColors.purpleHeroGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.royalPurple.withValues(alpha: .28),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.gold,
                                width: 2,
                              ),
                            ),
                            child: UserAvatar(
                              imageUrl: me?.avatarUrl ?? student?.avatarUrl,
                              size: AppSpace.s(context, 52),
                              animated: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  me?.displayName ?? student?.name ?? 'Student',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                if (me != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '@${me.username}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: AppColors.gold,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ],
                                const SizedBox(height: 2),
                                Text(
                                  me == null
                                      ? '${student?.level ?? 'O/L'} • ${student?.medium ?? 'Tamil'} medium'
                                      : '${me.level} • ${me.province.shortLabel} · SL #$national · Prov #$provincial',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                                if ((me?.email ?? student?.email) != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.mail_outline_rounded,
                                        size: 12,
                                        color: Colors.white.withValues(
                                          alpha: .7,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          (me?.email ?? student!.email)!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: Colors.white
                                                    .withValues(alpha: .75),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if ((me?.bio ?? '').isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    me!.bio,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: .85),
                                          height: 1.3,
                                        ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withValues(alpha: .2),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color:
                                          AppColors.gold.withValues(alpha: .55),
                                    ),
                                  ),
                                  child: Text(
                                    '${game.rank} Rank',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.gold,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpace.s(context, 12)),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          MetricPill(
                            icon: Icons.toll_rounded,
                            label: 'Coins',
                            value: '${game.coins}',
                            color: AppColors.gold,
                            onDark: true,
                          ),
                          MetricPill(
                            icon: Icons.local_fire_department_rounded,
                            label: 'Streak',
                            value: '${game.streakDays}d',
                            color: AppColors.streakOrange,
                            onDark: true,
                          ),
                          MetricPill(
                            icon: Icons.emoji_events_rounded,
                            label: 'Badges',
                            value: '$unlocked/$total',
                            color: AppColors.neonCyan,
                            onDark: true,
                          ),
                          MetricPill(
                            icon: Icons.people_alt_rounded,
                            label: 'Network',
                            value: '${connections.length}',
                            color: Colors.white,
                            onDark: true,
                          ),
                        ],
                      ),
                      if (me != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: .4),
                                  ),
                                ),
                                onPressed: () =>
                                    context.push('/u/${me.username}'),
                                child: const Text('View public'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.royalPurple,
                                ),
                                onPressed: () =>
                                    context.push(AppRoutes.profileEdit),
                                child: const Text('Edit profile'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (incoming.isNotEmpty) ...[
                SizedBox(height: AppSpace.s(context, 12)),
                Text(
                  'Connection requests',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                for (final req in incoming)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ClayCard(
                      compact: true,
                      color: Colors.white,
                      onTap: () => context.push('/u/${req.username}'),
                      child: Row(
                        children: [
                          UserAvatar(
                            imageUrl: req.avatarUrl,
                            size: 40,
                            animated: false,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  req.displayName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  '@${req.username}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.white
                                            .withValues(alpha: .7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                social.acceptConnection(req.id),
                            child: const Text('Accept'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              if (connections.isNotEmpty) ...[
                SizedBox(height: AppSpace.s(context, 12)),
                Text(
                  'Connections',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 86,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: connections.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final c = connections[index];
                      return GestureDetector(
                        onTap: () => context.push('/u/${c.username}'),
                        child: SizedBox(
                          width: 72,
                          child: Column(
                            children: [
                              UserAvatar(
                                imageUrl: c.avatarUrl,
                                size: 44,
                                animated: false,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c.displayName.split(' ').first,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: AppSpace.s(context, 12)),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 100),
                child: ClayCard(
                  compact: true,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Study progress',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _StatTile(
                              icon: Icons.menu_book_rounded,
                              label: 'Lessons',
                              value: '$lessonsDone',
                              hint: '+1 coin',
                              color: AppColors.electricPurple,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _StatTile(
                              icon: Icons.style_rounded,
                              label: 'Flash',
                              value: '$flashDone',
                              hint: '+2 coins',
                              color: AppColors.neonCyan,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _StatTile(
                              icon: Icons.quiz_rounded,
                              label: 'Quizzes',
                              value: '$quizzesDone',
                              hint: '+5 coins',
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpace.s(context, 12)),
              ClayCard(
                compact: true,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panda customization',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Equip looks from the reward shop.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: .7),
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _CustomizationChip(
                          label: 'Scholar Outfit',
                          selected: true,
                        ),
                        _CustomizationChip(label: 'Gold Frame'),
                        _CustomizationChip(label: 'Stickers'),
                        _CustomizationChip(label: 'Night Theme'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () => context.push('/rewards'),
                      icon: const Icon(Icons.storefront_rounded, size: 18),
                      label: const Text('Open reward shop'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpace.s(context, 16)),
              Row(
                children: [
                  Text(
                    'Achievements',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    '$unlocked unlocked',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.royalPurple,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (var i = 0; i < game.achievements.length; i++) ...[
                AnimatedEntrance(
                  delay: Duration(milliseconds: 35 * i),
                  child: _AchievementCard(achievement: game.achievements[i]),
                ),
                const SizedBox(height: 8),
              ],
              ClayCard(
                compact: true,
                color: Colors.white,
                onTap: () => context.go('/leaderboard'),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.leaderboard_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sri Lanka leaderboard',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            'National + province ranks · find classmates',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: .7),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.royalPurple,
                    ),
                  ],
                ),
              ),
              if (student?.email != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go(AppRoutes.signIn);
                    }
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign out'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String hint;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
          ),
          Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: .6),
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;

    return ClayCard(
      compact: true,
      color: unlocked ? Colors.white : const Color(0xFFF3F0FA),
      child: Row(
        children: [
          // Extra height so 3D badge float never overflows the card.
          SizedBox(
            width: 52,
            height: 56,
            child: Center(
              child: GameBadge(achievement: achievement, size: 48),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: unlocked
                            ? Colors.white
                            : Colors.white.withValues(alpha: .55),
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white
                            .withValues(alpha: unlocked ? .75 : .4),
                        height: 1.3,
                      ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(
              Icons.verified_rounded,
              color: AppColors.progressGreen,
              size: 20,
            ),
        ],
      ),
    );
  }
}

class _CustomizationChip extends StatelessWidget {
  const _CustomizationChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        gradient: selected ? AppColors.heroGradient : null,
        color: selected ? null : AppColors.darkCard,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? AppColors.neonPurple : Colors.white24,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
