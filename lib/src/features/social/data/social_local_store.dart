import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/public_student.dart';
import '../domain/student_connection.dart';

class SocialLocalStore {
  static const _filePrefix = 'studybuddy_social_';

  Future<File> _file({String? userId}) async {
    final dir = await getApplicationDocumentsDirectory();
    final safe = (userId ?? 'guest').replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return File('${dir.path}/$_filePrefix$safe.json');
  }

  Future<SocialSnapshot> load({String? userId}) async {
    try {
      final file = await _file(userId: userId);
      if (!await file.exists()) {
        return SocialSnapshot.empty();
      }
      final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final meJson = raw['me'] as Map<String, dynamic>?;
      final connections = (raw['connections'] as List<dynamic>? ?? const [])
          .map((e) => StudentConnection.fromJson(e as Map<String, dynamic>))
          .toList();
      return SocialSnapshot(
        me: meJson == null ? null : PublicStudent.fromJson(meJson),
        connections: connections,
      );
    } catch (_) {
      return SocialSnapshot.empty();
    }
  }

  Future<void> save(SocialSnapshot snapshot, {String? userId}) async {
    final file = await _file(userId: userId ?? snapshot.me?.id);
    await file.writeAsString(
      jsonEncode({
        'me': snapshot.me?.toJson(),
        'connections': snapshot.connections.map((c) => c.toJson()).toList(),
      }),
    );
  }
}

class SocialSnapshot {
  const SocialSnapshot({required this.me, required this.connections});

  factory SocialSnapshot.empty() =>
      const SocialSnapshot(me: null, connections: []);

  final PublicStudent? me;
  final List<StudentConnection> connections;
}
