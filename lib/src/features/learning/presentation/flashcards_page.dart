import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/coin_reward_dialog.dart';
import '../../../shared/widgets/learning_app_bar.dart';
import '../../../shared/widgets/particle_background.dart';
import '../../gamification/application/gamification_controller.dart';
import '../application/learning_providers.dart';

class FlashcardsPage extends ConsumerStatefulWidget {
  const FlashcardsPage({required this.subjectId, super.key});

  final String subjectId;

  @override
  ConsumerState<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends ConsumerState<FlashcardsPage> {
  var _index = 0;
  var _showBack = false;

  String get _subjectFallback => '/subjects/${widget.subjectId}';

  @override
  Widget build(BuildContext context) {
    final subject = ref.watch(subjectProvider(widget.subjectId));
    final cards =
        subject.chapters.expand((chapter) => chapter.flashcards).toList();
    final card = cards[_index];
    final alreadyDone = ref
        .watch(gamificationControllerProvider)
        .completedFlashcardSets
        .contains(widget.subjectId);

    return Scaffold(
      appBar: LearningAppBar(
        title: 'Flashcards',
        fallbackLocation: _subjectFallback,
      ),
      body: ParticleBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                '${_index + 1} of ${cards.length}  •  +2 coins on finish',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.neonCyan,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showBack = !_showBack),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: _showBack ? math.pi : 0),
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      final isBack = value > math.pi / 2;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, .001)
                          ..rotateY(value),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: isBack
                                ? AppColors.heroGradient
                                : const LinearGradient(
                                    colors: [
                                      AppColors.darkCard,
                                      Color(0xFF2D1B4E),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.royalPurple
                                    .withValues(alpha: .18),
                                blurRadius: 30,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..rotateY(isBack ? math.pi : 0),
                            child: Center(
                              child: Text(
                                isBack ? card.back : card.front,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      height: 1.2,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _index == 0
                          ? null
                          : () => setState(() {
                                _index -= 1;
                                _showBack = false;
                              }),
                      icon: const Icon(Icons.chevron_left_rounded),
                      label: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        if (_index == cards.length - 1) {
                          if (alreadyDone) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Flashcard set already claimed. +2 coins earned earlier.',
                                ),
                              ),
                            );
                            return;
                          }
                          final reward = ref
                              .read(gamificationControllerProvider.notifier)
                              .completeFlashcardReview(widget.subjectId);
                          await showCoinRewardDialog(context, reward);
                          return;
                        }

                        setState(() {
                          _index += 1;
                          _showBack = false;
                        });
                      },
                      icon: Icon(
                        _index == cards.length - 1
                            ? Icons.check_rounded
                            : Icons.chevron_right_rounded,
                      ),
                      label: Text(
                        _index == cards.length - 1 ? 'Finish' : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
