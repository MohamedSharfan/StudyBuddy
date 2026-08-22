import 'package:flutter/material.dart';

import '../../core/theme/responsive.dart';

class MetricPill extends StatelessWidget {
  const MetricPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onDark = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final valueColor = onDark ? Colors.white : color;
    final labelColor = onDark ? Colors.white70 : color.withValues(alpha: .85);
    final padH = AppSpace.s(context, 10);
    final padV = AppSpace.s(context, 7);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: onDark
            ? Colors.white.withValues(alpha: .14)
            : color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(14),
        border: onDark
            ? Border.all(color: Colors.white.withValues(alpha: .18))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: AppSpace.s(context, 16)),
          SizedBox(width: AppSpace.s(context, 6)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: valueColor,
                      height: 1.1,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      height: 1.1,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
