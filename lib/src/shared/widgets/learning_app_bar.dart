import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import 'brand_logo.dart';

/// App bar for nested learning screens with reliable back + Home actions.
class LearningAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LearningAppBar({
    required this.title,
    this.fallbackLocation = AppRoutes.home,
    this.actions,
    super.key,
  });

  final String title;
  final String fallbackLocation;
  final List<Widget>? actions;

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(fallbackLocation);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          const BrandLogo(size: 28, animated: false),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      leading: IconButton(
        tooltip: 'Back',
        onPressed: () => _goBack(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      actions: [
        ...?actions,
        IconButton(
          tooltip: 'Home',
          onPressed: () => context.go(AppRoutes.home),
          icon: const Icon(Icons.home_rounded),
          color: AppColors.royalPurple,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
