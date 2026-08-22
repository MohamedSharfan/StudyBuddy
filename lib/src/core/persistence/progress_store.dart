import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../features/gamification/domain/achievement.dart';
import '../../features/gamification/domain/gamification_state.dart';

/// Fast local persistence for study progress (lessons / quizzes / flashcards).
/// Keyed per user so demo + Google accounts stay isolated.
class ProgressStore {
  ProgressStore._();
  static final instance = ProgressStore._();

  static const _filePrefix = 'studybuddy_progress_';

  final Map<String, GamificationState> _memory = {};

  Future<File> _fileFor(String userId) async {
    final dir = await getApplicationDocumentsDirectory();
    final safe = userId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return File('${dir.path}/$_filePrefix$safe.json');
  }

  GamificationState? peek(String userId) => _memory[userId];

  Future<GamificationState?> load(String userId) async {
    if (_memory.containsKey(userId)) {
      return _memory[userId];
    }
    try {
      final file = await _fileFor(userId);
      if (!await file.exists()) return null;
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final state = decodeProgress(json);
      _memory[userId] = state;
      return state;
    } catch (_) {
      return null;
    }
  }

  Future<void> save(String userId, GamificationState state) async {
    _memory[userId] = state;
    try {
      final file = await _fileFor(userId);
      await file.writeAsString(jsonEncode(encodeProgress(state)));
    } catch (_) {}
  }

  void clearMemory(String userId) => _memory.remove(userId);
}

Map<String, dynamic> encodeProgress(GamificationState state) => {
      'coins': state.coins,
      'streakDays': state.streakDays,
      'rank': state.rank,
      'lifetimeEarned': state.lifetimeEarned,
      'lastActivityDay': state.lastActivityDay,
      'completedLessons': state.completedLessons.toList(),
      'completedQuizzes': state.completedQuizzes.toList(),
      'completedFlashcardSets': state.completedFlashcardSets.toList(),
      'achievements': [
        for (final a in state.achievements)
          {'code': a.code, 'unlocked': a.unlocked},
      ],
    };

GamificationState decodeProgress(Map<String, dynamic> json) {
  final base = GamificationState.empty();
  final unlockedCodes = {
    for (final raw in (json['achievements'] as List<dynamic>? ?? const []))
      if (raw is Map && raw['unlocked'] == true) raw['code'] as String,
  };

  return base.copyWith(
    coins: json['coins'] as int? ?? 0,
    streakDays: json['streakDays'] as int? ?? 0,
    rank: json['rank'] as String? ?? 'Bronze',
    lifetimeEarned: json['lifetimeEarned'] as int? ?? 0,
    lastActivityDay: json['lastActivityDay'] as String?,
    completedLessons: {
      for (final id in (json['completedLessons'] as List<dynamic>? ?? const []))
        id.toString(),
    },
    completedQuizzes: {
      for (final id in (json['completedQuizzes'] as List<dynamic>? ?? const []))
        id.toString(),
    },
    completedFlashcardSets: {
      for (final id
          in (json['completedFlashcardSets'] as List<dynamic>? ?? const []))
        id.toString(),
    },
    achievements: [
      for (final a in base.achievements)
        Achievement(
          code: a.code,
          title: a.title,
          description: a.description,
          icon: a.icon,
          unlocked: unlockedCodes.contains(a.code),
        ),
    ],
  );
}
