import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/clay_card.dart';
import '../../../shared/widgets/coin_reward_dialog.dart';
import '../../../shared/widgets/learning_app_bar.dart';
import '../../../shared/widgets/animated_card.dart';
import '../../../shared/widgets/particle_background.dart';
import '../../gamification/application/gamification_controller.dart';
import '../application/learning_providers.dart';
import '../domain/chapter.dart';

class NoteReaderPage extends ConsumerWidget {
  const NoteReaderPage({
    required this.subjectId,
    required this.noteId,
    super.key,
  });

  final String subjectId;
  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(
      noteProvider((subjectId: subjectId, noteId: noteId)),
    );
    final subject = ref.watch(subjectProvider(subjectId));
    final alreadyDone = ref
        .watch(gamificationControllerProvider)
        .completedLessons
        .contains(note.id);

    // Find current chapter and note index
    Chapter? currentChapter;
    int currentNoteIndex = 0;
    int currentChapterIndex = 0;
    
    for (int i = 0; i < subject.chapters.length; i++) {
      final chapter = subject.chapters[i];
      for (int j = 0; j < chapter.notes.length; j++) {
        if (chapter.notes[j].id == noteId) {
          currentChapter = chapter;
          currentNoteIndex = j;
          currentChapterIndex = i;
          break;
        }
      }
      if (currentChapter != null) break;
    }

    // Determine next note/chapter
    String? nextNoteId;
    String nextButtonLabel = 'Next Lesson';
    
    if (currentChapter != null) {
      if (currentNoteIndex < currentChapter.notes.length - 1) {
        // Next note in same chapter
        nextNoteId = currentChapter.notes[currentNoteIndex + 1].id;
      } else if (currentChapterIndex < subject.chapters.length - 1) {
        // First note of next chapter
        nextNoteId = subject.chapters[currentChapterIndex + 1].notes.first.id;
        nextButtonLabel = 'Next Chapter';
      }
    }

    return Scaffold(
      appBar: LearningAppBar(
        title: 'Learn',
        fallbackLocation: '/subjects/$subjectId',
      ),
      body: ParticleBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Chapter indicator with animation
            if (currentChapter != null)
              FloatingAnimation(
                offset: 5,
                duration: const Duration(seconds: 3),
                child: AnimatedCard(
                  gradient: AppColors.purpleHeroGradient,
                  elevation: 6,
                  borderRadius: 12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.folder_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            currentChapter.title,
                            style: GoogleFonts.notoSansTamil(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            PulseAnimation(
              minScale: 0.99,
              maxScale: 1.01,
              duration: const Duration(seconds: 2),
              child: Text(
                note.title,
                style: GoogleFonts.notoSansTamil(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.purplePinkGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '${note.estimatedMinutes} min',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.purpleGoldGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars_rounded, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      const Text(
                        '+1 coin',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AnimatedCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkCard,
                  Color(0xFF2D1B4E),
                ],
              ),
              elevation: 6,
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  note.summary,
                  style: GoogleFonts.notoSansTamil(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Use Markdown widget for proper formatting
            AnimatedCard(
              color: AppColors.darkCard,
              elevation: 4,
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: MarkdownBody(
                  data: note.body,
                  styleSheet: MarkdownStyleSheet(
                    p: GoogleFonts.notoSansTamil(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.white,
                    ),
                    strong: GoogleFonts.notoSansTamil(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    h1: GoogleFonts.notoSansTamil(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                      color: AppColors.neonCyan,
                    ),
                    h2: GoogleFonts.notoSansTamil(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                      color: AppColors.brightPurple,
                    ),
                    h3: GoogleFonts.notoSansTamil(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      color: Colors.white70,
                    ),
                    listBullet: GoogleFonts.notoSansTamil(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.white,
                    ),
                    listIndent: 24,
                    blockSpacing: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AnimatedCard(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gold.withValues(alpha: 0.2),
                  AppColors.sunnyYellow.withValues(alpha: 0.15),
                ],
              ),
              elevation: 6,
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PulseAnimation(
                      child: const Icon(
                        Icons.lightbulb_rounded,
                        color: AppColors.gold,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exam tip',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            note.examTip,
                            style: GoogleFonts.notoSansTamil(
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            AnimatedCard(
              gradient: alreadyDone
                  ? AppColors.purpleGreenGradient
                  : AppColors.purplePinkGradient,
              elevation: 8,
              borderRadius: 18,
              onTap: alreadyDone
                  ? null
                  : () async {
                      final reward = ref
                          .read(gamificationControllerProvider.notifier)
                          .completeLesson(note.id);
                      await showCoinRewardDialog(context, reward);
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      alreadyDone
                          ? Icons.verified_rounded
                          : Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      alreadyDone ? 'Lesson completed' : 'Mark lesson complete',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Next lesson/chapter button
            if (nextNoteId != null) ...[
              const SizedBox(height: 12),
              AnimatedCard(
                gradient: AppColors.purpleBlueGradient,
                elevation: 6,
                borderRadius: 18,
                onTap: () {
                  context.go('/subjects/$subjectId/notes/$nextNoteId');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nextButtonLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Chapter selection button
            AnimatedCard(
              color: AppColors.darkCard,
              elevation: 4,
              borderRadius: 18,
              onTap: () {
                _showChapterSelector(context, subject, subjectId);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.list_rounded,
                      color: AppColors.neonCyan,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Choose Chapter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChapterSelector(BuildContext context, dynamic subject, String subjectId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A0B2E), Color(0xFF0D0221)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: AppColors.royalPurple),
                    const SizedBox(width: 12),
                    Text(
                      'Select Chapter',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: subject.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = subject.chapters[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClayCard(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to first note of selected chapter
                          final firstNote = chapter.notes.first;
                          context.go('/subjects/$subjectId/notes/${firstNote.id}');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.royalPurple.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.royalPurple,
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
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${chapter.notes.length} lessons • ${chapter.flashcards.length} flashcards',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white60,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
