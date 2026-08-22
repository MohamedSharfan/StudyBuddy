import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/gamification/domain/achievement.dart';

/// Game-style 3D badge with depth, shine, and idle motion.
class GameBadge extends StatefulWidget {
  const GameBadge({
    required this.achievement,
    this.size = 72,
    this.animated = false,
    super.key,
  });

  final Achievement achievement;
  final double size;
  final bool animated;

  @override
  State<GameBadge> createState() => _GameBadgeState();
}

class _GameBadgeState extends State<GameBadge>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animated && widget.achievement.unlocked) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3200),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  IconData get _icon {
    switch (widget.achievement.icon) {
      case 'quiz':
        return Icons.quiz_rounded;
      case 'style':
        return Icons.style_rounded;
      case 'auto_stories':
        return Icons.auto_stories_rounded;
      case 'emoji_events':
        return Icons.emoji_events_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'workspace_premium':
        return Icons.workspace_premium_rounded;
      case 'toll':
        return Icons.toll_rounded;
      case 'menu_book':
      default:
        return Icons.menu_book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = widget.achievement.unlocked;
    final badge = _badgeBody(unlocked);

    final controller = _controller;
    if (controller == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: badge,
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value * 3.1415926535 * 2;
        final tiltX = math.sin(t) * .06;
        final tiltY = math.cos(t * .85) * .08;
        final lift = math.sin(t) * 1.2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, .0014)
            ..translateByDouble(0, lift, 0, 1)
            ..rotateX(tiltX)
            ..rotateY(tiltY),
          child: child,
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size + 4,
        child: badge,
      ),
    );
  }

  Widget _badgeBody(bool unlocked) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: const Offset(2, 3),
          child: Container(
            width: widget.size * .88,
            height: widget.size * .88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: unlocked ? .18 : .08),
            ),
          ),
        ),
        Container(
          width: widget.size * .9,
          height: widget.size * .9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: unlocked
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFF3BF),
                      AppColors.gold,
                      Color(0xFFB45309),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFE5E7EB),
                      Colors.grey.shade500,
                      Colors.grey.shade700,
                    ],
                  ),
            boxShadow: [
              BoxShadow(
                color: (unlocked ? AppColors.gold : Colors.black)
                    .withValues(alpha: unlocked ? .35 : .14),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: .55),
              width: 2,
            ),
          ),
          child: Icon(
            unlocked ? _icon : Icons.lock_rounded,
            color: unlocked ? const Color(0xFF78350F) : Colors.white70,
            size: widget.size * .38,
          ),
        ),
      ],
    );
  }
}
