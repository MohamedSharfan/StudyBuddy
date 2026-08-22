import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'brand_logo.dart';

/// Shows the signed-in Gmail photo when available, otherwise the brand logo.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    this.imageUrl,
    this.size = 48,
    this.animated = true,
    super.key,
  });

  final String? imageUrl;
  final double size;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final radius = size * .28;
    final url = imageUrl?.trim();

    if (url == null || url.isEmpty) {
      return BrandLogo(size: size, animated: animated);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.royalPurple.withValues(alpha: .22),
            blurRadius: size * .2,
            offset: Offset(0, size * .08),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: .85), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              BrandLogo(size: size, animated: false),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return ColoredBox(
              color: AppColors.lavender,
              child: Center(
                child: SizedBox(
                  width: size * .28,
                  height: size * .28,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
