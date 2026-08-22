import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/responsive.dart';
import '../../../shared/widgets/learning_app_bar.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../application/social_controller.dart';
import '../domain/sri_lanka_province.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _headline;
  late final TextEditingController _bio;
  late final TextEditingController _avatarUrl;
  SriLankaProvince _province = SriLankaProvince.western;
  String _level = 'O/L';
  String? _error;
  bool _busy = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _username = TextEditingController();
    _headline = TextEditingController();
    _bio = TextEditingController();
    _avatarUrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final me = ref.read(socialControllerProvider).me;
    if (me == null) {
      setState(() => _ready = true);
      return;
    }
    _name.text = me.displayName;
    _username.text = me.username;
    _headline.text = me.headline;
    _bio.text = me.bio;
    _avatarUrl.text = me.avatarUrl ?? '';
    _province = me.province;
    _level = me.level;
    setState(() => _ready = true);
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _headline.dispose();
    _bio.dispose();
    _avatarUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final error =
        await ref.read(socialControllerProvider.notifier).updateMyProfile(
              displayName: _name.text,
              username: _username.text,
              province: _province,
              bio: _bio.text,
              headline: _headline.text,
              avatarUrl: _avatarUrl.text.trim().isEmpty
                  ? null
                  : _avatarUrl.text.trim(),
              level: _level,
            );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        appBar: LearningAppBar(title: 'Edit profile'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final me = ref.watch(socialControllerProvider).me;
    final pad = AppSpace.s(context, 16);

    if (me == null) {
      return Scaffold(
        appBar: const LearningAppBar(title: 'Edit profile'),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/onboarding'),
            child: const Text('Claim a username first'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const LearningAppBar(title: 'Edit profile'),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkSpaceGradient),
        child: ListView(
          padding: EdgeInsets.all(pad),
          children: [
            Center(
              child: UserAvatar(
                imageUrl: _avatarUrl.text.trim().isEmpty
                    ? me.avatarUrl
                    : _avatarUrl.text.trim(),
                size: 72,
                animated: false,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixText: '@',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _headline,
              decoration: const InputDecoration(
                labelText: 'Headline',
                hintText: 'O/L Science · Western Province',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bio,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'About / description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _avatarUrl,
              decoration: const InputDecoration(
                labelText: 'Profile photo URL',
                hintText: 'https://…',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<SriLankaProvince>(
              key: ValueKey('province-$_province'),
              initialValue: _province,
              decoration: const InputDecoration(labelText: 'Province'),
              items: [
                for (final p in SriLankaProvince.values)
                  DropdownMenuItem(value: p, child: Text(p.label)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _province = v);
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: ValueKey('level-$_level'),
              initialValue: _level,
              decoration: const InputDecoration(labelText: 'Level'),
              items: const [
                DropdownMenuItem(value: 'O/L', child: Text('O/L')),
                DropdownMenuItem(value: 'A/L', child: Text('A/L')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _level = v);
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: Text(_busy ? 'Saving…' : 'Save profile'),
            ),
          ],
        ),
      ),
    );
  }
}
