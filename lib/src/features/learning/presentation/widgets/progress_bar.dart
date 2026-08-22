import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    required this.value,
    this.height = 9,
    super.key,
  });

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 1)),
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, child) {
          return LinearProgressIndicator(
            value: animatedValue,
            minHeight: height,
            color: AppColors.progressGreen,
            backgroundColor: AppColors.lavender,
          );
        },
      ),
    );
  }
}
