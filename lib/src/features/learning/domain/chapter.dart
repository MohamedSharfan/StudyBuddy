import 'flashcard.dart';
import 'lesson_note.dart';
import 'quiz_question.dart';

class Chapter {
  const Chapter({
    required this.id,
    required this.title,
    required this.progress,
    required this.notes,
    required this.flashcards,
    required this.quizQuestions,
  });

  final String id;
  final String title;
  final double progress;
  final List<LessonNote> notes;
  final List<Flashcard> flashcards;
  final List<QuizQuestion> quizQuestions;
}
