import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_environment.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/animated_entrance.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/particle_background.dart';
import '../../social/application/social_controller.dart';
import '../application/auth_controller.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(authBusyProvider);
    final error = ref.watch(authErrorProvider);
    final supabaseReady = AppEnvironment.isSupabaseReady;
    final pad = AppSpace.s(context, 20);
    final logoSize = AppSpace.s(context, 108);

    return Scaffold(
      body: ParticleBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(pad, pad * .6, pad, pad),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(flex: 2),
                        AnimatedEntrance(
                          child: Center(
                            child: BrandLogo(
                              size: logoSize,
                              animated: false,
                              heroTag: 'brand-logo',
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpace.s(context, 18)),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 80),
                          child: Center(
                            child: Text(
                              'StudyBuddy',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      height: 1.05,
                                      letterSpacing: -.4,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpace.s(context, 8)),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 140),
                          child: Text(
                            'Play • Learn • Level Up — your AI study companion for O/L & A/L.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                          ),
                        ),
                        if (error != null) ...[
                          SizedBox(height: AppSpace.s(context, 14)),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppSpace.s(context, 12)),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: .12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              error,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                        const Spacer(flex: 3),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 200),
                          child: FilledButton.icon(
                            onPressed: busy
                                ? null
                                : () async {
                                    final ok = await ref
                                        .read(authControllerProvider.notifier)
                                        .signInWithGoogle();
                                    if (!ok || !context.mounted) return;
                                    await ref
                                        .read(socialControllerProvider.notifier)
                                        .ensureReady();
                                    if (!context.mounted) return;
                                    final hasProfile = ref
                                        .read(socialControllerProvider)
                                        .hasProfile;
                                    context.go(
                                      hasProfile
                                          ? AppRoutes.home
                                          : AppRoutes.onboarding,
                                    );
                                  },
                            icon: busy
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white.withValues(alpha: .9),
                                    ),
                                  )
                                : const Icon(Icons.mail_rounded, size: 20),
                            label: Text(
                              busy ? 'Connecting…' : 'Continue with Gmail',
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpace.s(context, 8)),
                        if (!supabaseReady ||
                            !AppEnvironment.isGoogleSignInReady)
                          Text(
                            !supabaseReady
                                ? AppEnvironment.supabaseConfigHint
                                : AppEnvironment.googleSignInMissingHint,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.white54,
                                  height: 1.3,
                                  fontSize: 11,
                                ),
                          ),
                        SizedBox(height: AppSpace.s(context, 10)),
                        OutlinedButton(
                  onPressed: busy
                      ? null
                      : () async {
                          ref
                              .read(authControllerProvider.notifier)
                              .continueAsDemoStudent();
                          await ref
                              .read(socialControllerProvider.notifier)
                              .ensureReady();
                          if (!context.mounted) return;
                          final hasProfile =
                              ref.read(socialControllerProvider).hasProfile;
                          context.go(
                            hasProfile
                                ? AppRoutes.home
                                : AppRoutes.onboarding,
                          );
                        },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size.fromHeight(
                              AppSpace.s(context, 46),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Explore demo (no login)',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
