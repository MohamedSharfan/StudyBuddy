import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/responsive.dart';

class ClayCard extends StatelessWidget {
  const ClayCard({
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.compact = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cardColor = (color == null || color == Colors.white) ? AppColors.darkCard : color!;
    final radius = AppSpace.cardRadius(context);
    final pad = padding ??
        EdgeInsets.all(AppSpace.s(context, compact ? 12 : 14));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          padding: pad,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: AppColors.brightPurple.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepSpacePurple.withValues(alpha: .5),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.neonPurple.withValues(alpha: .15),
                blurRadius: 8,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
