import 'chapter.dart';

class StudySubject {
  const StudySubject({
    required this.id,
    required this.name,
    required this.icon,
    required this.progress,
    required this.chapters,
    required this.colorValue,
  });

  final String id;
  final String name;
  final String icon;
  final double progress;
  final List<Chapter> chapters;
  final int colorValue;
}
