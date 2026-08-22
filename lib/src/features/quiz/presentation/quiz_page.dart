import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/gamification/application/gamification_controller.dart';
import '../../../features/gamification/domain/reward_result.dart';
import '../../../shared/widgets/clay_card.dart';
import '../../../shared/widgets/coin_reward_dialog.dart';
import '../../../shared/widgets/learning_app_bar.dart';
import '../../../shared/widgets/particle_background.dart';
import '../../learning/application/learning_providers.dart';
import '../../learning/domain/quiz_question.dart';
import '../application/quiz_controller.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({required this.subjectId, super.key});

  final String subjectId;

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  RewardResult? _reward;
  var _rewardHandled = false;

  String get _subjectFallback => '/subjects/${widget.subjectId}';

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(quizQuestionsProvider(widget.subjectId));
    final session = ref.watch(quizControllerProvider);
    final controller = ref.read(quizControllerProvider.notifier);

    if (questions.isEmpty) {
      return Scaffold(
        appBar: LearningAppBar(
          title: 'Quiz',
          fallbackLocation: _subjectFallback,
        ),
        body: const Center(child: Text('No quiz questions available yet.')),
      );
    }

    if (session.finished) {
      if (!_rewardHandled) {
        _rewardHandled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) {
            return;
          }
          final reward =
              ref.read(gamificationControllerProvider.notifier).completeQuiz(
                    subjectId: widget.subjectId,
                    correctAnswers: session.correctAnswers,
                    totalQuestions: questions.length,
                  );
          setState(() => _reward = reward);
          if (reward.hasReward) {
            await showCoinRewardDialog(context, reward);
          }
        });
      }

      final percent = questions.isEmpty
          ? 0
          : ((session.correctAnswers / questions.length) * 100).round();
      final passed = _reward?.passed ??
          percent >= GamificationController.quizPassPercent;

      return _QuizResult(
        subjectId: widget.subjectId,
        correctAnswers: session.correctAnswers,
        totalQuestions: questions.length,
        percent: percent,
        passed: passed,
        coinsAwarded: _reward?.coinsAwarded ?? 0,
        alreadyClaimed: _reward?.alreadyClaimed ?? false,
        message: _reward?.subtitle,
        onRetry: () {
          setState(() {
            _reward = null;
            _rewardHandled = false;
          });
          controller.restart();
        },
      );
    }

    final question = questions[session.currentIndex];
    final progress = (session.currentIndex + 1) / questions.length;

    return Scaffold(
      appBar: LearningAppBar(
        title: 'Quiz',
        fallbackLocation: _subjectFallback,
      ),
      body: ParticleBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClayCard(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Question ${session.currentIndex + 1} of ${questions.length}',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppColors.royalPurple,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: .16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Pass ${GamificationController.quizPassPercent}% • +5',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: const Color(0xFF92400E),
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        color: AppColors.royalPurple,
                        backgroundColor: AppColors.lavender,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question.prompt,
                      style: _getTamilTextStyle(
                        context,
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              height: 1.3,
                            ),
                      ),
                    ),
                    if (question.isShortAnswer || question.isEssay) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.royalPurple.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              size: 18,
                              color: AppColors.royalPurple,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                question.isEssay
                                    ? 'நீண்ட விடை கேள்வி (Essay Question)'
                                    : 'குறுகிய விடை கேள்வி (Short Answer)',
                                style: _getTamilTextStyle(
                                  context,
                                  Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: AppColors.royalPurple,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (session.answered)
                _AnswerBanner(
                  correct: session.selectedOptionId == question.correctOptionId,
                ),
              const SizedBox(height: 18),
              Expanded(
                child: question.isShortAnswer || question.isEssay
                    ? _WrittenAnswerSection(
                        question: question,
                        answered: session.answered,
                      )
                    : ListView.separated(
                        itemCount: question.options.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final option = question.options[index];

                          return _OptionTile(
                            label: option.label,
                            selected: session.selectedOptionId == option.id,
                            correct: session.answered &&
                                question.correctOptionId == option.id,
                            wrong: session.answered &&
                                session.selectedOptionId == option.id &&
                                question.correctOptionId != option.id,
                            onTap: () => controller.answer(
                              optionId: option.id,
                              correctOptionId: question.correctOptionId ?? '',
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: session.answered
                    ? ClayCard(
                        key: ValueKey(question.id),
                        color: AppColors.darkCard,
                        child: Text(
                          question.explanation,
                          style: _getTamilTextStyle(
                            context,
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.6,
                                ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: session.answered
                    ? () => controller.next(questions.length)
                    : null,
                icon: Icon(
                  session.currentIndex == questions.length - 1
                      ? Icons.emoji_events_rounded
                      : Icons.arrow_forward_rounded,
                ),
                label: Text(
                  session.currentIndex == questions.length - 1
                      ? 'Finish quiz'
                      : 'Next question',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = correct
        ? AppColors.progressGreen
        : wrong
            ? Colors.redAccent
            : selected
                ? AppColors.royalPurple
                : Theme.of(context).colorScheme.outlineVariant;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              color.withValues(alpha: correct || wrong || selected ? .14 : .05),
          border: Border.all(color: color, width: correct || wrong ? 2 : 1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                correct
                    ? Icons.check_rounded
                    : wrong
                        ? Icons.close_rounded
                        : Icons.circle_outlined,
                size: 18,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: _getTamilTextStyle(
                  context,
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerBanner extends StatelessWidget {
  const _AnswerBanner({required this.correct});

  final bool correct;

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.progressGreen : Colors.redAccent;

    return ClayCard(
      color: color.withValues(alpha: .12),
      child: Row(
        children: [
          Icon(
            correct
                ? Icons.celebration_rounded
                : Icons.sentiment_satisfied_rounded,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              correct
                  ? 'Nice hit! Pass with ${GamificationController.quizPassPercent}%+ to mine +5 coins.'
                  : 'Close. The correct answer is highlighted below.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizResult extends StatelessWidget {
  const _QuizResult({
    required this.subjectId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.percent,
    required this.passed,
    required this.coinsAwarded,
    required this.alreadyClaimed,
    required this.onRetry,
    this.message,
  });

  final String subjectId;
  final int correctAnswers;
  final int totalQuestions;
  final int percent;
  final bool passed;
  final int coinsAwarded;
  final bool alreadyClaimed;
  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final accent = passed ? AppColors.gold : Colors.redAccent;

    return Scaffold(
      appBar: LearningAppBar(
        title: passed ? 'Quiz passed' : 'Try again',
        fallbackLocation: '/subjects/$subjectId',
      ),
      body: ParticleBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClayCard(
                color: accent.withValues(alpha: .14),
                child: Column(
                  children: [
                    Icon(
                      passed
                          ? Icons.emoji_events_rounded
                          : Icons.refresh_rounded,
                      color: accent,
                      size: 92,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '$percent%',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$correctAnswers correct out of $totalQuestions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      passed
                          ? 'PASSED'
                          : 'NEED ${GamificationController.quizPassPercent}%+',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ClayCard(
                color: AppColors.darkCard,
                child: Text(
                  message ??
                      (passed
                          ? alreadyClaimed
                              ? 'Quiz already claimed earlier.'
                              : 'You mined +$coinsAwarded coins.'
                          : 'Score ${GamificationController.quizPassPercent}% or higher to earn coins and pass.'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                      ),
                ),
              ),
              const SizedBox(height: 18),
              if (!passed) ...[
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Try again'),
                ),
                const SizedBox(height: 10),
              ],
              OutlinedButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Back to home'),
              ),
              if (passed) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go('/subjects/$subjectId'),
                  child: const Text('Back to subject'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to apply Tamil font for Tamil text
TextStyle? _getTamilTextStyle(BuildContext context, TextStyle? baseStyle) {
  if (baseStyle == null) return null;
  
  return baseStyle.copyWith(
    fontFamily: GoogleFonts.notoSansTamil().fontFamily,
  );
}

// Widget for Short Answer and Essay questions
class _WrittenAnswerSection extends ConsumerWidget {
  const _WrittenAnswerSection({
    required this.question,
    required this.answered,
  });

  final QuizQuestion question;
  final bool answered;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClayCard(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      question.isEssay
                          ? Icons.description_outlined
                          : Icons.short_text_rounded,
                      color: AppColors.royalPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        question.isEssay
                            ? 'உங்கள் கட்டுரை விடையை எழுதுங்கள்'
                            : 'உங்கள் குறுகிய விடையை எழுதுங்கள்',
                        style: _getTamilTextStyle(
                          context,
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.royalPurple,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.royalPurple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: TextField(
                    maxLines: question.isEssay ? 10 : 4,
                    enabled: !answered,
                    style: _getTamilTextStyle(
                      context,
                      Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                    ),
                    decoration: InputDecoration(
                      hintText: question.isEssay
                          ? 'இங்கே உங்கள் கட்டுரையை எழுதுங்கள்...'
                          : 'இங்கே உங்கள் விடையை எழுதுங்கள்...',
                      hintStyle: _getTamilTextStyle(
                        context,
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade400,
                            ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: const Color(0xFF92400E),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'குறிப்பு: உங்கள் விடையை எழுதிய பிறகு "நான் எழுதினேன்" என்பதைக் கிளிக் செய்து சரியான விடையைப் பார்க்கவும்.',
                          style: _getTamilTextStyle(
                            context,
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF92400E),
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!answered) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                // For written answers, we mark them as "completed" 
                // without checking correctness
                final controller =
                    ref.read(quizControllerProvider.notifier);
                controller.answer(
                  optionId: 'written-answer',
                  correctOptionId: 'written-answer',
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.royalPurple,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                'நான் எழுதினேன் - விடையைப் பார்க்கவும்',
                style: _getTamilTextStyle(
                  context,
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
