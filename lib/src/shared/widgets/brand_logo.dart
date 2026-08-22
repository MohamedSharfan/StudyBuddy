import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';

/// StudyBuddy crest logo with soft 3D float — clipped so it never overflows.
class BrandLogo extends StatefulWidget {
  const BrandLogo({
    this.size = 72,
    this.animated = false,
    this.heroTag,
    super.key,
  });

  final double size;
  final bool animated;
  final Object? heroTag;

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3600),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.size * .22;
    final logo = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: .5),
            blurRadius: widget.size * .3,
            spreadRadius: widget.size * .05,
            offset: Offset(0, widget.size * .1),
          ),
          BoxShadow(
            color: AppColors.neonCyan.withValues(alpha: .3),
            blurRadius: widget.size * .2,
            offset: Offset(-widget.size * .08, -widget.size * .05),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          AppAssets.brandLogo,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ColoredBox(
            color: AppColors.lavender,
            child: Icon(
              Icons.school_rounded,
              color: AppColors.royalPurple,
              size: widget.size * .42,
            ),
          ),
        ),
      ),
    );

    final wrapped = widget.heroTag == null
        ? logo
        : Hero(tag: widget.heroTag!, child: logo);

    if (!widget.animated || _controller == null) {
      return wrapped;
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        final t = _controller!.value * math.pi * 2;
        final dy = math.sin(t * 2) * 4.0;
        final tiltX = math.sin(t * 1.5) * 0.15;
        final tiltY = math.cos(t) * 0.25;
        final rotateZ = math.sin(t * 0.5) * 0.05;
        final scale = 1 + math.sin(t * 2) * .03;

        // Extra headroom so the float never paints outside layout bounds.
        return SizedBox(
          width: widget.size,
          height: widget.size + 12,
          child: Center(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, .002) // Stronger perspective
                ..translateByDouble(0, dy, 0, 1)
                ..scaleByDouble(scale, scale, scale, 1)
                ..rotateX(tiltX)
                ..rotateY(tiltY)
                ..rotateZ(rotateZ),
              child: child,
            ),
          ),
        );
      },
      child: wrapped,
    );
  }
}
