import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Fade + slide + soft 3D pop-in for friendlier page motion.
class AnimatedEntrance extends StatefulWidget {
  const AnimatedEntrance({
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 14),
    this.duration = const Duration(milliseconds: 320),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Offset offset;
  final Duration duration;

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;
  late final Animation<double> _tilt;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _opacity = curve;
    _scale = Tween<double>(begin: .94, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slide = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(curve);
    _tilt = Tween<double>(begin: .08, end: 0).animate(curve);

    Future<void>.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, .001)
              ..translateByDouble(_slide.value.dx, _slide.value.dy, 0, 1)
              ..scaleByDouble(_scale.value, _scale.value, 1, 1)
              ..rotateX(_tilt.value * math.pi / 12),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
