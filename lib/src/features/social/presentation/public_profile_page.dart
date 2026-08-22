import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/clay_card.dart';
import '../../../shared/widgets/game_badge.dart';
import '../../../shared/widgets/learning_app_bar.dart';
import '../../../shared/widgets/metric_pill.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../gamification/domain/achievement.dart';
import '../../gamification/application/gamification_controller.dart';
import '../application/social_controller.dart';
import '../domain/student_connection.dart';
import 'share_profile_sheet.dart';

class PublicProfilePage extends ConsumerWidget {
  const PublicProfilePage({required this.username, super.key});

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final network = ref.watch(socialControllerProvider);
    final social = ref.read(socialControllerProvider.notifier);
    final student = social.byUsername(username);
    final me = network.me;
    final pad = AppSpace.s(context, 16);

    if (student == null) {
      return Scaffold(
        appBar: const LearningAppBar(title: 'Profile'),
        body: Center(
          child: Text('No student found for @$username'),
        ),
      );
    }

    final isMe = me?.id == student.id;
    final status = isMe
        ? ConnectionStatus.none
        : social.connectionStatus(student.id);
    final national = social.nationalRankOf(student.id);
    final provincial = social.provinceRankOf(student.id, student.province);
    final achievements = ref.watch(gamificationControllerProvider).achievements;
    final badgeLookup = {
      for (final a in achievements) a.code: a,
    };

    return Scaffold(
      appBar: LearningAppBar(
        title: '@${student.username}',
        actions: [
          IconButton(
            tooltip: 'Share',
            onPressed: () => showShareProfileSheet(context, student: student),
            icon: const Icon(Icons.qr_code_2_rounded),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkSpaceGradient),
        child: ListView(
          padding: EdgeInsets.fromLTRB(pad, 8, pad, 28),
          children: [
            ClayCard(
              compact: true,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserAvatar(
                        imageUrl: student.avatarUrl,
                        size: AppSpace.s(context, 64),
                        animated: false,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.displayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            Text(
                              '@${student.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: AppColors.royalPurple,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              student.headline.isEmpty
                                  ? '${student.level} · ${student.province.label}'
                                  : student.headline,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        AppColors.ink.withValues(alpha: .6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (student.bio.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      student.bio,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      MetricPill(
                        icon: Icons.toll_rounded,
                        label: 'Coins',
                        value: '${student.coins}',
                        color: AppColors.gold,
                      ),
                      MetricPill(
                        icon: Icons.emoji_events_rounded,
                        label: 'Rank',
                        value: student.rank,
                        color: AppColors.royalPurple,
                      ),
                      MetricPill(
                        icon: Icons.flag_rounded,
                        label: 'SL #',
                        value: '$national',
                        color: AppColors.neonCyan,
                      ),
                      MetricPill(
                        icon: Icons.map_rounded,
                        label: student.province.shortLabel,
                        value: '#$provincial',
                        color: AppColors.streakOrange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (isMe)
                    FilledButton.icon(
                      onPressed: () => context.push('/profile/edit'),
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text('Edit profile'),
                    )
                  else
                    _ConnectionActions(
                      status: status,
                      onConnect: () => social.sendConnectionRequest(student.id),
                      onAccept: () => social.acceptConnection(student.id),
                      onRemove: () => social.removeConnection(student.id),
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSpace.s(context, 14)),
            Text(
              'Badges',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            if (student.badgeCodes.isEmpty)
              Text(
                'No badges unlocked yet.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.ink.withValues(alpha: .5),
                    ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final code in student.badgeCodes)
                    SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          GameBadge(
                            achievement: badgeLookup[code] ??
                                Achievement(
                                  code: code,
                                  title: code,
                                  description: '',
                                  icon: 'emoji_events',
                                  unlocked: true,
                                ),
                            size: 52,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            badgeLookup[code]?.title ?? code,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            SizedBox(height: AppSpace.s(context, 16)),
            ClayCard(
              compact: true,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Study card',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Province', value: student.province.label),
                  _InfoRow(label: 'Level', value: student.level),
                  _InfoRow(label: 'Medium', value: student.medium),
                  _InfoRow(label: 'Streak', value: '${student.streakDays} days'),
                  if (student.email != null && (isMe || status == ConnectionStatus.connected))
                    _InfoRow(label: 'Email', value: student.email!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.ink.withValues(alpha: .5),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionActions extends StatelessWidget {
  const _ConnectionActions({
    required this.status,
    required this.onConnect,
    required this.onAccept,
    required this.onRemove,
  });

  final ConnectionStatus status;
  final VoidCallback onConnect;
  final VoidCallback onAccept;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ConnectionStatus.connected:
        return OutlinedButton.icon(
          onPressed: onRemove,
          icon: const Icon(Icons.check_circle_rounded, size: 18),
          label: const Text('Connected · Remove'),
        );
      case ConnectionStatus.pendingOutgoing:
        return OutlinedButton.icon(
          onPressed: onRemove,
          icon: const Icon(Icons.hourglass_top_rounded, size: 18),
          label: const Text('Request sent · Cancel'),
        );
      case ConnectionStatus.pendingIncoming:
        return Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onAccept,
                child: const Text('Accept'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: onRemove,
                child: const Text('Ignore'),
              ),
            ),
          ],
        );
      case ConnectionStatus.none:
        return FilledButton.icon(
          onPressed: onConnect,
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
          label: const Text('Connect'),
        );
    }
  }
}
