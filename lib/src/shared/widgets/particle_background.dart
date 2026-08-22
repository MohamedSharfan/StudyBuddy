import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({
    this.child,
    this.particleCount = 50,
    super.key,
  });

  final Widget? child;
  final int particleCount;

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = List.generate(
      widget.particleCount,
      (index) => _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: _random.nextDouble() * 0.2 + 0.05,
        size: _random.nextDouble() * 3 + 1,
        color: [
          AppColors.neonCyan,
          AppColors.brightPurple,
          AppColors.neonPurple,
          Colors.white,
        ][_random.nextInt(4)],
        depth: _random.nextDouble(),
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
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.darkSpaceGradient,
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                progress: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
    required this.depth,
  });

  double x;
  double y;
  double speed;
  double size;
  Color color;
  double depth;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.progress,
  });

  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: 0.3 + (0.7 * particle.depth))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size / 2);

      // Parallax movement based on depth
      var currentY = particle.y - (progress * particle.speed * (1 + particle.depth));
      if (currentY < -0.1) {
        currentY = 1.0 + (currentY % 1.0);
      }

      final dx = particle.x * size.width;
      final dy = currentY * size.height;
      final radius = particle.size * (0.5 + particle.depth);

      // Slight lateral sway
      final sway = sin((progress * 2 * pi) + (particle.x * 10)) * 10 * particle.depth;

      canvas.drawCircle(Offset(dx + sway, dy), radius, paint);
      
      // Draw a bright core for 3D glowing effect
      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.8 * particle.depth)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx + sway, dy), radius / 2, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
