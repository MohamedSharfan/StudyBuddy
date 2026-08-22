import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A card with 3D tilt effect and hover animation
class AnimatedCard extends StatefulWidget {
  const AnimatedCard({
    required this.child,
    this.onTap,
    this.gradient,
    this.color,
    this.borderRadius = 20,
    this.enableTilt = true,
    this.elevation = 8,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  final double borderRadius;
  final bool enableTilt;
  final double elevation;

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  double _tiltX = 0;
  double _tiltY = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent details) {
    if (!widget.enableTilt) return;
    final size = context.size;
    if (size == null) return;
    
    setState(() {
      _tiltX = (details.localPosition.dy - size.height / 2) / (size.height / 2);
      _tiltY = (details.localPosition.dx - size.width / 2) / (size.width / 2);
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: GestureDetector(
        onTapDown: widget.onTap != null
            ? (_) {
                setState(() => _isPressed = true);
                _controller.forward();
              }
            : null,
        onTapUp: widget.onTap != null
            ? (_) {
                setState(() => _isPressed = false);
                _controller.reverse();
                widget.onTap?.call();
              }
            : null,
        onTapCancel: widget.onTap != null
            ? () {
                setState(() => _isPressed = false);
                _controller.reverse();
              }
            : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 150),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, val, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(-_tiltX * 0.15)
                  ..rotateY(_tiltY * 0.15),
                child: child,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: widget.gradient,
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: (widget.color ?? AppColors.brightPurple).withValues(alpha: 0.3),
                    blurRadius: _isPressed ? widget.elevation / 2 : widget.elevation + (_tiltX.abs() + _tiltY.abs()) * 10,
                    offset: Offset(_tiltY * -5, _isPressed ? 2 : 4 + _tiltX * -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating animation effect
class FloatingAnimation extends StatefulWidget {
  const FloatingAnimation({
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.offset = 10.0,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final double offset;

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: -widget.offset,
      end: widget.offset,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Pulse animation effect
class PulseAnimation extends StatefulWidget {
  const PulseAnimation({
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// Shimmer effect for loading or highlighting
class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({
    required this.child,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
    this.duration = const Duration(milliseconds: 1500),
    super.key,
  });

  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                math.max(0.0, _controller.value - 0.3),
                _controller.value,
                math.min(1.0, _controller.value + 0.3),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Rotate animation
class RotateAnimation extends StatefulWidget {
  const RotateAnimation({
    required this.child,
    this.duration = const Duration(seconds: 2),
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  State<RotateAnimation> createState() => _RotateAnimationState();
}

class _RotateAnimationState extends State<RotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }
}
