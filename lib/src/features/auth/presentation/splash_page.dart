import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_environment.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../social/application/social_controller.dart';
import '../application/auth_controller.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 700), _route);
  }

  Future<void> _route() async {
    if (!mounted) return;

    await ref.read(socialControllerProvider.notifier).ensureReady();
    if (!mounted) return;

    final student = ref.read(authControllerProvider);
    final hasProfile = ref.read(socialControllerProvider).hasProfile;

    if (student != null && AppEnvironment.isSupabaseReady) {
      context.go(hasProfile ? AppRoutes.home : AppRoutes.onboarding);
      return;
    }

    // Demo returning user with saved local profile.
    if (student != null && hasProfile) {
      context.go(AppRoutes.home);
      return;
    }

    context.go(AppRoutes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = AppSpace.s(context, 112);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandLogo(
                size: logoSize,
                animated: false,
                heroTag: 'brand-logo',
              ),
              SizedBox(height: AppSpace.s(context, 16)),
              const Text(
                'StudyBuddy',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  letterSpacing: -.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Play • Learn • Level Up',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .78),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: .6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
