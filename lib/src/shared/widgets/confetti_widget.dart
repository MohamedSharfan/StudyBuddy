import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiWidget extends StatefulWidget {
  const ConfettiWidget({
    this.numberOfParticles = 50,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ],
    super.key,
  });

  final int numberOfParticles;
  final List<Color> colors;

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _particles = List.generate(
      widget.numberOfParticles,
      (index) => Particle(
        color: widget.colors[math.Random().nextInt(widget.colors.length)],
        initialX: math.Random().nextDouble(),
        initialY: -0.1,
        velocityX: (math.Random().nextDouble() - 0.5) * 2,
        velocityY: math.Random().nextDouble() * 2 + 1,
        rotation: math.Random().nextDouble() * math.pi * 2,
        rotationSpeed: (math.Random().nextDouble() - 0.5) * 4,
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
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  Particle({
    required this.color,
    required this.initialX,
    required this.initialY,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.rotationSpeed,
  });

  final Color color;
  final double initialX;
  final double initialY;
  final double velocityX;
  final double velocityY;
  final double rotation;
  final double rotationSpeed;
}

class ConfettiPainter extends CustomPainter {
  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  final List<Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final x = size.width * particle.initialX + (particle.velocityX * 100 * progress);
      final y = size.height * particle.initialY + (particle.velocityY * 200 * progress);
      
      if (y > size.height) continue;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: 1.0 - progress * 0.5);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + particle.rotationSpeed * progress * math.pi);
      
      // Draw confetti as small rectangles
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-5, -2, 10, 4),
          const Radius.circular(2),
        ),
        paint,
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
