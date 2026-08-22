import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/brand_logo.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/particle_background.dart';
import '../../social/application/social_controller.dart';
import '../../social/domain/sri_lanka_province.dart';
import '../application/auth_controller.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _usernameCtrl = TextEditingController();
  String _level = 'O/L';
  String _medium = 'Tamil';
  SriLankaProvince _province = SriLankaProvince.western;
  String? _usernameError;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(socialControllerProvider.notifier).ensureReady();
      if (!mounted) return;
      if (ref.read(socialControllerProvider).hasProfile) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    var auth = ref.read(authControllerProvider);
    if (auth == null) {
      ref.read(authControllerProvider.notifier).continueAsDemoStudent(
            level: _level,
            medium: _medium,
          );
      auth = ref.read(authControllerProvider);
    }
    if (auth == null) return;

    setState(() {
      _busy = true;
      _usernameError = null;
    });

    final error = await ref.read(socialControllerProvider.notifier).claimProfile(
          auth: auth,
          username: _usernameCtrl.text,
          province: _province,
          level: _level,
          medium: _medium,
        );

    if (!mounted) return;
    setState(() => _busy = false);

    if (error != null) {
      setState(() => _usernameError = error);
      return;
    }
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(authControllerProvider);
    final pad = AppSpace.s(context, 20);

    return Scaffold(
      body: ParticleBackground(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(pad),
            children: [
              Row(
                children: [
                  BrandLogo(size: AppSpace.s(context, 40), animated: false),
                  const SizedBox(width: 10),
                  Text(
                    'Create your student profile',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
              SizedBox(height: AppSpace.s(context, 14)),
              if (student != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpace.s(context, 12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      UserAvatar(
                        imageUrl: student.avatarUrl,
                        size: AppSpace.s(context, 44),
                        animated: false,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            if (student.email != null)
                              Text(
                                student.email!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: .7),
                                    ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: AppSpace.s(context, 18)),
              Text(
                'Pick a unique username',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Friends search you like LinkedIn — e.g. nisha_galle',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: .7),
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameCtrl,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixText: '@',
                  hintText: 'your_username',
                  errorText: _usernameError,
                ),
                onChanged: (_) {
                  if (_usernameError != null) {
                    setState(() => _usernameError = null);
                  }
                },
              ),
              SizedBox(height: AppSpace.s(context, 16)),
              Text(
                'Your province (Sri Lanka)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<SriLankaProvince>(
                initialValue: _province,
                decoration: const InputDecoration(),
                items: [
                  for (final p in SriLankaProvince.values)
                    DropdownMenuItem(value: p, child: Text(p.label)),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _province = v);
                },
              ),
              SizedBox(height: AppSpace.s(context, 16)),
              _ChoiceGroup(
                title: 'Education level',
                value: _level,
                values: const ['O/L', 'A/L'],
                onChanged: (value) => setState(() => _level = value),
              ),
              SizedBox(height: AppSpace.s(context, 14)),
              _ChoiceGroup(
                title: 'Medium',
                value: _medium,
                values: const ['Tamil'],
                onChanged: (value) => setState(() => _medium = value),
              ),
              SizedBox(height: AppSpace.s(context, 24)),
              FilledButton(
                onPressed: _busy ? null : _submit,
                child: Text(_busy ? 'Saving…' : 'Enter StudyBuddy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceGroup extends StatelessWidget {
  const _ChoiceGroup({
    required this.title,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String title;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final item in values)
              ChoiceChip(
                label: Text(item),
                selected: value == item,
                selectedColor: AppColors.vibrantPurple,
                onSelected: (_) => onChanged(item),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ],
    );
  }
}
