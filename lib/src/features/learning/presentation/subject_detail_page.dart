import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/learning_app_bar.dart';
import '../../../shared/widgets/animated_card.dart';
import '../application/learning_providers.dart';
import 'widgets/progress_bar.dart';
import 'widgets/subject_icon.dart';
import '../../../shared/widgets/particle_background.dart';

class SubjectDetailPage extends ConsumerWidget {
  const SubjectDetailPage({required this.subjectId, super.key});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(subjectProvider(subjectId));
    final color = Color(subject.colorValue);
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width < 360 ? 1 : 2;
    final aspectRatio = width < 360 ? 2.4 : (width < 400 ? 1.15 : 1.08);

    return Scaffold(
      appBar: LearningAppBar(
        title: subject.name,
        fallbackLocation: AppRoutes.home,
      ),
      body: ParticleBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Hero card with floating animation
            FloatingAnimation(
              duration: const Duration(seconds: 4),
              offset: 8,
              child: AnimatedCard(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withValues(alpha: 0.8),
                    color.withValues(alpha: 0.9),
                  ],
                ),
                elevation: 12,
                borderRadius: 24,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PulseAnimation(
                        child: Icon(
                          subjectIcon(subject.icon),
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        subject.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${subject.chapters.length} chapters',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ProgressBar(value: subject.progress),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: aspectRatio,
              ),
              children: [
                _ActionTile(
                  icon: Icons.article_rounded,
                  title: 'Learn',
                  gradient: AppColors.purpleHeroGradient,
                  onTap: () {
                    final firstNote = subject.chapters.first.notes.first;
                    context.push(
                      '/subjects/${subject.id}/notes/${firstNote.id}',
                    );
                  },
                ),
                _ActionTile(
                  icon: Icons.style_rounded,
                  title: 'Flashcards',
                  gradient: AppColors.purplePinkGradient,
                  onTap: () =>
                      context.push('/subjects/${subject.id}/flashcards'),
                ),
                _ActionTile(
                  icon: Icons.quiz_rounded,
                  title: 'Quiz',
                  gradient: AppColors.purpleBlueGradient,
                  onTap: () => context.push('/subjects/${subject.id}/quiz'),
                ),
                _ActionTile(
                  icon: Icons.smart_toy_rounded,
                  title: 'Ask AI Panda',
                  gradient: AppColors.purpleCyanGradient,
                  onTap: () => context.go('/ai-panda'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Chapters',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 12),
            for (final (index, chapter) in subject.chapters.indexed) ...[
              AnimatedCard(
                onTap: () {
                  // Navigate to first note of the chapter
                  final firstNote = chapter.notes.first;
                  context.push('/subjects/${subject.id}/notes/${firstNote.id}');
                },
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkCard,
                    color.withValues(alpha: 0.25),
                  ],
                ),
                elevation: 6,
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedCard(
                            gradient: LinearGradient(
                              colors: [
                                color,
                                color.withValues(alpha: 0.8),
                              ],
                            ),
                            elevation: 4,
                            borderRadius: 12,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              chapter.title,
                              style: GoogleFonts.notoSansTamil(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                height: 1.3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ProgressBar(value: chapter.progress),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${chapter.notes.length} lessons',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.style_outlined,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${chapter.flashcards.length} cards',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      gradient: gradient,
      elevation: 8,
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PulseAnimation(
              minScale: 0.98,
              maxScale: 1.02,
              child: Icon(icon, color: Colors.white, size: 38),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
