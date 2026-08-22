import 'package:flutter/material.dart';

/// Compact, consistent spacing scaled by screen width — keeps UI tight on phones.
class AppSpace {
  const AppSpace._();

  static double scale(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final shortest = width < height ? width : height;
    if (shortest < 340) return .82;
    if (shortest < 380) return .90;
    if (shortest < 420) return .96;
    if (width > 700) return 1.08;
    return 1;
  }

  static double s(BuildContext context, double value) => value * scale(context);

  static EdgeInsets pagePadding(BuildContext context) {
    final g = s(context, 14);
    return EdgeInsets.fromLTRB(g, s(context, 8), g, s(context, 16));
  }

  static double cardRadius(BuildContext context) => s(context, 16);

  static double textScale(BuildContext context) {
    // Cap system font scaling so huge accessibility sizes don't blow layouts.
    final factor = MediaQuery.textScalerOf(context).scale(1);
    return factor.clamp(0.9, 1.15);
  }
}
