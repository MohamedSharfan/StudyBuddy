import 'package:flutter/material.dart';

import 'brand_logo.dart';

/// Back-compat alias — StudyBuddy now uses the crest logo everywhere.
class PandaAvatar extends StatelessWidget {
  const PandaAvatar({
    this.size = 64,
    this.backgroundColor,
    this.animated = true,
    this.heroTag,
    super.key,
  });

  final double size;
  final Color? backgroundColor;
  final bool animated;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return BrandLogo(
      size: size,
      animated: animated,
      heroTag: heroTag,
    );
  }
}
