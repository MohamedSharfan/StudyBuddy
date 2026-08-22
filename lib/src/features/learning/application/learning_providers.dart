import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../gamification/application/gamification_controller.dart';
import '../../gamification/domain/gamification_state.dart';
import '../data/seed_learning_repository.dart';
import '../domain/chapter.dart';
import '../domain/lesson_note.dart';
import '../domain/quiz_question.dart';
import '../domain/subject.dart';

final learningRepositoryProvider = Provider<SeedLearningRepository>(
  (ref) => const SeedLearningRepository(),
);

/// Subjects with progress derived from real completed lessons (not dummy %).
final subjectsProvider = Provider<List<StudySubject>>((ref) {
  final base = ref.watch(learningRepositoryProvider).getSubjects();
  final game = ref.watch(gamificationControllerProvider);
  return [
    for (final subject in base) _withLiveProgress(subject, game),
  ];
});

final subjectProvider = Provider.family<StudySubject, String>((ref, id) {
  return ref.watch(subjectsProvider).firstWhere((s) => s.id == id);
});

final noteProvider =
    Provider.family<LessonNote, ({String subjectId, String noteId})>(
  (ref, args) => ref
      .watch(learningRepositoryProvider)
      .noteById(args.subjectId, args.noteId),
);

final quizQuestionsProvider = Provider.family<List<QuizQuestion>, String>(
  (ref, subjectId) =>
      ref.watch(learningRepositoryProvider).quizForSubject(subjectId),
);

StudySubject _withLiveProgress(StudySubject subject, GamificationState game) {
  final chapters = [
    for (final chapter in subject.chapters)
      Chapter(
        id: chapter.id,
        title: chapter.title,
        notes: chapter.notes,
        flashcards: chapter.flashcards,
        quizQuestions: chapter.quizQuestions,
        progress: chapter.notes.isEmpty
            ? 0
            : chapter.notes
                    .where((n) => game.completedLessons.contains(n.id))
                    .length /
                chapter.notes.length,
      ),
  ];

  final allNotes = chapters.expand((c) => c.notes).toList();
  final lessonProgress = allNotes.isEmpty
      ? 0.0
      : allNotes.where((n) => game.completedLessons.contains(n.id)).length /
          allNotes.length;

  // Mix in quiz / flashcard completion for the subject card feel.
  var bonus = 0.0;
  if (game.completedFlashcardSets.contains(subject.id)) bonus += .1;
  if (game.completedQuizzes.contains(subject.id)) bonus += .15;
  final progress = (lessonProgress * 0.75 + bonus).clamp(0.0, 1.0);

  return StudySubject(
    id: subject.id,
    name: subject.name,
    icon: subject.icon,
    progress: progress,
    chapters: chapters,
    colorValue: subject.colorValue,
  );
}
