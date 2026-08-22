import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/animated_entrance.dart';
import '../../../shared/widgets/clay_card.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/particle_background.dart';
import '../../social/application/social_controller.dart';
import '../../social/domain/public_student.dart';
import '../../social/domain/sri_lanka_province.dart';

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  SriLankaProvince? _province;
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final network = ref.watch(socialControllerProvider);
    final social = ref.read(socialControllerProvider.notifier);
    final me = network.me;
    final pad = AppSpace.s(context, 16);

    final searching = _query.trim().isNotEmpty;
    final ranked = searching
        ? social.search(_query)
        : social.rankings(province: _province);

    final myNational = me == null ? 0 : social.nationalRankOf(me.id);
    final myProvince = me == null
        ? 0
        : social.provinceRankOf(me.id, me.province);

    return Scaffold(
      body: ParticleBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(pad, 10, pad, 8),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedEntrance(
                        child: Text(
                          'Sri Lanka rankings',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'National & province boards · search by @username',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: .7),
                            ),
                      ),
                      SizedBox(height: AppSpace.s(context, 12)),
                      TextField(
                        controller: _search,
                        decoration: InputDecoration(
                          hintText: 'Search students by username…',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _search.clear();
                                    setState(() => _query = '');
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                        onChanged: (v) => setState(() => _query = v),
                      ),
                      SizedBox(height: AppSpace.s(context, 10)),
                      if (!searching) ...[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterChip(
                                label: 'All Sri Lanka',
                                selected: _province == null,
                                onTap: () => setState(() => _province = null),
                              ),
                              for (final p in SriLankaProvince.values) ...[
                                const SizedBox(width: 6),
                                _FilterChip(
                                  label: p.shortLabel,
                                  selected: _province == p,
                                  onTap: () => setState(() => _province = p),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpace.s(context, 12)),
                        if (me != null)
                          AnimatedEntrance(
                            delay: const Duration(milliseconds: 60),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(AppSpace.s(context, 14)),
                              decoration: BoxDecoration(
                                gradient: AppColors.heroGradient,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  UserAvatar(
                                    imageUrl: me.avatarUrl,
                                    size: 44,
                                    animated: false,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '@${me.username}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Text(
                                          'SL #$myNational · ${me.province.shortLabel} #$myProvince',
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: .75),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${me.coins}',
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                      SizedBox(height: AppSpace.s(context, 12)),
                      Text(
                        searching
                            ? 'Search results'
                            : (_province == null
                                ? 'National board'
                                : '${_province!.label} board'),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              if (ranked.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(pad),
                    child: Text(
                      searching
                          ? 'No students match “$_query”.'
                          : 'No students in this board yet.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: .7),
                          ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(pad, 0, pad, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final student = ranked[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _RankRow(
                            place: index + 1,
                            student: student,
                            highlight: student.isLocalUser,
                            onTap: () =>
                                context.push('/u/${student.username}'),
                          ),
                        );
                      },
                      childCount: ranked.length,
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.heroGradient : null,
          color: selected ? null : AppColors.darkCard,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : AppColors.brightPurple.withValues(alpha: .4),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.place,
    required this.student,
    required this.onTap,
    this.highlight = false,
  });

  final int place;
  final PublicStudent student;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      compact: true,
      color: highlight ? AppColors.vibrantPurple.withValues(alpha: 0.3) : AppColors.darkCard,
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '#$place',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: place <= 3
                        ? AppColors.gold
                        : Colors.white70,
                  ),
            ),
          ),
          UserAvatar(
            imageUrl: student.avatarUrl,
            size: 40,
            animated: false,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Text(
                  '@${student.username} · ${student.province.shortLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white60,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${student.coins}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.gold,
                    ),
              ),
              Text(
                student.rank,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neonCyan,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
