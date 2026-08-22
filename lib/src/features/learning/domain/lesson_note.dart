class LessonNote {
  const LessonNote({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.examTip,
    required this.estimatedMinutes,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final String examTip;
  final int estimatedMinutes;
}
