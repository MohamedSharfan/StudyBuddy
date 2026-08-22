import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_environment.dart';
import '../../features/gamification/domain/achievement.dart';
import '../../features/gamification/domain/gamification_state.dart';
import '../../features/social/domain/public_student.dart';
import '../../features/social/domain/sri_lanka_province.dart';
import '../../features/social/domain/student_connection.dart';

/// Optional cloud sync. Fails soft if tables aren't migrated yet.
class SupabaseSync {
  const SupabaseSync._();

  static bool get _ready => AppEnvironment.isSupabaseReady;

  static SupabaseClient? get _client {
    if (!_ready) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static String? get _uid {
    final client = _client;
    return client?.auth.currentUser?.id;
  }

  static Future<GamificationState?> loadProgress(String userId) async {
    final client = _client;
    if (client == null || _uid == null || _uid != userId) return null;
    try {
      final profile = await client
          .from('profiles')
          .select(
            'coins, streak_days, current_rank, lifetime_earned, last_activity_day, badge_codes',
          )
          .eq('id', userId)
          .maybeSingle();
      if (profile == null) return null;

      final lessons = await client
          .from('user_lesson_completions')
          .select('lesson_id')
          .eq('user_id', userId);
      final quizzes = await client
          .from('user_quiz_completions')
          .select('subject_id')
          .eq('user_id', userId);
      final flashes = await client
          .from('user_flashcard_completions')
          .select('subject_id')
          .eq('user_id', userId);

      final base = GamificationState.empty();
      final badgeCodes = ((profile['badge_codes'] as List<dynamic>?) ?? const [])
          .map((e) => e.toString())
          .toSet();

      return base.copyWith(
        coins: profile['coins'] as int? ?? 0,
        streakDays: profile['streak_days'] as int? ?? 0,
        rank: profile['current_rank'] as String? ?? 'Bronze',
        lifetimeEarned: profile['lifetime_earned'] as int? ?? 0,
        lastActivityDay: profile['last_activity_day']?.toString(),
        completedLessons: {
          for (final row in lessons) row['lesson_id'].toString(),
        },
        completedQuizzes: {
          for (final row in quizzes) row['subject_id'].toString(),
        },
        completedFlashcardSets: {
          for (final row in flashes) row['subject_id'].toString(),
        },
        achievements: [
          for (final a in base.achievements)
            Achievement(
              code: a.code,
              title: a.title,
              description: a.description,
              icon: a.icon,
              unlocked: badgeCodes.contains(a.code),
            ),
        ],
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveProgress(String userId, GamificationState state) async {
    final client = _client;
    if (client == null || _uid == null || _uid != userId) return;
    try {
      await client.from('profiles').upsert({
        'id': userId,
        'coins': state.coins,
        'streak_days': state.streakDays,
        'current_rank': state.rank,
        'lifetime_earned': state.lifetimeEarned,
        'last_activity_day': state.lastActivityDay,
        'badge_codes': [
          for (final a in state.achievements)
            if (a.unlocked) a.code,
        ],
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {}
  }

  static Future<void> recordLesson(String userId, String lessonId) async {
    final client = _client;
    if (client == null || _uid != userId) return;
    try {
      await client.from('user_lesson_completions').upsert({
        'user_id': userId,
        'lesson_id': lessonId,
      });
    } catch (_) {}
  }

  static Future<void> recordQuiz(
    String userId,
    String subjectId,
    int percent,
  ) async {
    final client = _client;
    if (client == null || _uid != userId) return;
    try {
      await client.from('user_quiz_completions').upsert({
        'user_id': userId,
        'subject_id': subjectId,
        'score_percent': percent,
      });
    } catch (_) {}
  }

  static Future<void> recordFlashcards(String userId, String subjectId) async {
    final client = _client;
    if (client == null || _uid != userId) return;
    try {
      await client.from('user_flashcard_completions').upsert({
        'user_id': userId,
        'subject_id': subjectId,
      });
    } catch (_) {}
  }

  static Future<void> upsertProfile(PublicStudent me) async {
    final client = _client;
    if (client == null || _uid == null || _uid != me.id) return;
    try {
      await client.from('profiles').upsert({
        'id': me.id,
        'username': me.username,
        'display_name': me.displayName,
        'education_level': me.level,
        'medium': me.medium,
        'province': me.province.name,
        'bio': me.bio,
        'headline': me.headline,
        'avatar_url': me.avatarUrl,
        'email': me.email,
        'coins': me.coins,
        'streak_days': me.streakDays,
        'current_rank': me.rank,
        'badge_codes': me.badgeCodes,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (_) {}
  }

  static Future<PublicStudent?> loadMyProfile(String userId) async {
    final client = _client;
    if (client == null || _uid != userId) return null;
    try {
      final row = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (row == null || row['username'] == null) return null;
      return _studentFromRow(row, isLocal: true);
    } catch (_) {
      return null;
    }
  }

  static Future<List<PublicStudent>> loadLeaderboard() async {
    final client = _client;
    if (client == null || _uid == null) return const [];
    try {
      final rows = await client
          .from('profiles')
          .select()
          .not('username', 'is', null)
          .order('coins', ascending: false)
          .limit(100);
      return [
        for (final row in rows)
          _studentFromRow(row, isLocal: row['id'] == _uid),
      ];
    } catch (_) {
      return const [];
    }
  }

  static Future<List<StudentConnection>> loadConnections(String userId) async {
    final client = _client;
    if (client == null || _uid != userId) return const [];
    try {
      final rows = await client
          .from('student_connections')
          .select()
          .or('from_user_id.eq.$userId,to_user_id.eq.$userId');
      return [
        for (final row in rows)
          StudentConnection(
            fromUserId: row['from_user_id'] as String,
            toUserId: row['to_user_id'] as String,
            status: row['status'] as String,
            createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ??
                DateTime.now(),
          ),
      ];
    } catch (_) {
      return const [];
    }
  }

  static Future<void> upsertConnection(StudentConnection c) async {
    final client = _client;
    if (client == null || _uid == null) return;
    try {
      await client.from('student_connections').upsert({
        'from_user_id': c.fromUserId,
        'to_user_id': c.toUserId,
        'status': c.status,
      });
    } catch (_) {}
  }

  static Future<void> deleteConnection(String a, String b) async {
    final client = _client;
    if (client == null || _uid == null) return;
    try {
      await client
          .from('student_connections')
          .delete()
          .or('and(from_user_id.eq.$a,to_user_id.eq.$b),and(from_user_id.eq.$b,to_user_id.eq.$a)');
    } catch (_) {}
  }

  static PublicStudent _studentFromRow(
    Map<String, dynamic> row, {
    required bool isLocal,
  }) {
    return PublicStudent(
      id: row['id'] as String,
      username: (row['username'] as String? ?? '').toLowerCase(),
      displayName: row['display_name'] as String? ?? 'Student',
      province: SriLankaProvince.tryParse(row['province'] as String?) ??
          SriLankaProvince.western,
      level: row['education_level'] as String? ?? 'O/L',
      medium: row['medium'] as String? ?? 'Tamil',
      coins: row['coins'] as int? ?? 0,
      rank: row['current_rank'] as String? ?? 'Bronze',
      streakDays: row['streak_days'] as int? ?? 0,
      badgeCodes: ((row['badge_codes'] as List<dynamic>?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      bio: row['bio'] as String? ?? '',
      headline: row['headline'] as String? ?? '',
      avatarUrl: row['avatar_url'] as String?,
      email: row['email'] as String?,
      isLocalUser: isLocal,
    );
  }
}
