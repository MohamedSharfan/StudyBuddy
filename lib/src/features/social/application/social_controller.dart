import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/supabase_sync.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/student_profile.dart';
import '../../gamification/application/gamification_controller.dart';
import '../data/social_local_store.dart';
import '../domain/public_student.dart';
import '../domain/sri_lanka_province.dart';
import '../domain/student_connection.dart';

final socialControllerProvider =
    NotifierProvider<SocialController, SocialNetworkState>(
  SocialController.new,
);

class SocialNetworkState {
  const SocialNetworkState({
    required this.students,
    required this.connections,
    required this.ready,
  });

  factory SocialNetworkState.initial() => const SocialNetworkState(
        students: [],
        connections: [],
        ready: false,
      );

  final List<PublicStudent> students;
  final List<StudentConnection> connections;
  final bool ready;

  PublicStudent? get me {
    for (final s in students) {
      if (s.isLocalUser) return s;
    }
    return null;
  }

  bool get hasProfile => me != null && me!.username.isNotEmpty;

  SocialNetworkState copyWith({
    List<PublicStudent>? students,
    List<StudentConnection>? connections,
    bool? ready,
  }) {
    return SocialNetworkState(
      students: students ?? this.students,
      connections: connections ?? this.connections,
      ready: ready ?? this.ready,
    );
  }
}

class SocialController extends Notifier<SocialNetworkState> {
  final _store = SocialLocalStore();

  static final usernamePattern = RegExp(r'^[a-z0-9_]{3,20}$');

  @override
  SocialNetworkState build() {
    ref.listen(gamificationControllerProvider, (_, next) {
      final current = state.me;
      if (current == null || !state.ready) return;
      _replaceMe(
        current.copyWith(
          coins: next.coins,
          rank: next.rank,
          streakDays: next.streakDays,
          badgeCodes: next.achievements
              .where((a) => a.unlocked)
              .map((a) => a.code)
              .toList(),
        ),
        persist: true,
      );
    });

    ref.listen(authControllerProvider, (prev, next) {
      if (next?.id != prev?.id) {
        Future.microtask(_hydrate);
      } else if (next != null && state.me != null) {
        _replaceMe(
          state.me!.copyWith(
            id: next.id,
            displayName: next.name,
            email: next.email,
            avatarUrl: next.avatarUrl ?? state.me!.avatarUrl,
            level: next.level,
            medium: next.medium,
          ),
          persist: true,
        );
      }
    });

    Future.microtask(_hydrate);
    return SocialNetworkState.initial();
  }

  Future<void> ensureReady() async {
    if (state.ready) return;
    await _hydrate();
  }

  Future<void> _hydrate() async {
    final auth = ref.read(authControllerProvider);
    final game = ref.read(gamificationControllerProvider);
    final snap = await _store.load(userId: auth?.id);

    PublicStudent? me = snap.me;

    // Prefer cloud profile when signed in (survives reinstall / new device).
    if (auth != null) {
      final cloudMe = await SupabaseSync.loadMyProfile(auth.id);
      if (cloudMe != null) {
        me = cloudMe;
      }
    }

    if (me != null && auth != null) {
      me = me.copyWith(
        id: auth.id,
        displayName: auth.name.isNotEmpty ? auth.name : me.displayName,
        email: auth.email ?? me.email,
        avatarUrl: auth.avatarUrl ?? me.avatarUrl,
        level: auth.level,
        medium: auth.medium,
        coins: game.coins,
        rank: game.rank,
        streakDays: game.streakDays,
        badgeCodes: game.achievements
            .where((a) => a.unlocked)
            .map((a) => a.code)
            .toList(),
        isLocalUser: true,
      );
      // Restore auth social fields for UI.
      ref.read(authControllerProvider.notifier).updateProfileDetails(
            username: me.username,
            province: me.province.name,
            bio: me.bio,
            headline: me.headline,
            avatarUrl: me.avatarUrl,
          );
    } else if (me != null && auth == null) {
      me = null; // Don't show another account's profile while logged out.
    }

    final cloudPeople = await SupabaseSync.loadLeaderboard();
    final cloudConnections = auth == null
        ? <StudentConnection>[]
        : await SupabaseSync.loadConnections(auth.id);

    final connections = cloudConnections.isNotEmpty
        ? cloudConnections
        : snap.connections;

    state = SocialNetworkState(
      students: _mergeStudents(me, cloudPeople),
      connections: connections,
      ready: true,
    );

    if (me != null) {
      await _store.save(
        SocialSnapshot(me: me, connections: connections),
        userId: me.id,
      );
    }
  }

  List<PublicStudent> _mergeStudents(
    PublicStudent? me,
    List<PublicStudent> others,
  ) {
    final byId = <String, PublicStudent>{
      for (final s in others) s.id: s.copyWith(isLocalUser: false),
    };
    if (me != null) {
      byId[me.id] = me;
    }
    return byId.values.toList()
      ..sort((a, b) => b.coins.compareTo(a.coins));
  }

  Future<void> _persist() async {
    final me = state.me;
    await _store.save(
      SocialSnapshot(me: me, connections: state.connections),
      userId: me?.id,
    );
    if (me != null) {
      await SupabaseSync.upsertProfile(me);
    }
  }

  void _replaceMe(PublicStudent me, {required bool persist}) {
    final others = [
      for (final s in state.students)
        if (s.id != me.id) s.copyWith(isLocalUser: false),
    ];
    state = state.copyWith(students: [me, ...others]);
    if (persist) {
      Future.microtask(_persist);
    }
  }

  bool isUsernameAvailable(String username, {String? exceptUserId}) {
    final key = username.trim().toLowerCase();
    return !state.students.any(
      (s) =>
          s.username == key &&
          (exceptUserId == null || s.id != exceptUserId),
    );
  }

  String? validateUsername(String raw, {String? exceptUserId}) {
    final username = raw.trim().toLowerCase();
    if (!usernamePattern.hasMatch(username)) {
      return 'Use 3–20 chars: lowercase letters, numbers, underscore.';
    }
    if (!isUsernameAvailable(username, exceptUserId: exceptUserId)) {
      return 'That username is already taken.';
    }
    return null;
  }

  Future<String?> claimProfile({
    required StudentProfile auth,
    required String username,
    required SriLankaProvince province,
    required String level,
    required String medium,
    String bio = '',
    String headline = '',
  }) async {
    final error = validateUsername(username, exceptUserId: auth.id);
    if (error != null) return error;

    final game = ref.read(gamificationControllerProvider);
    final me = PublicStudent(
      id: auth.id,
      username: username.trim().toLowerCase(),
      displayName: auth.name,
      province: province,
      level: level,
      medium: medium,
      coins: game.coins,
      rank: game.rank,
      streakDays: game.streakDays,
      badgeCodes: game.achievements
          .where((a) => a.unlocked)
          .map((a) => a.code)
          .toList(),
      bio: bio.trim(),
      headline: headline.trim().isEmpty
          ? '$level · ${province.shortLabel} Province'
          : headline.trim(),
      avatarUrl: auth.avatarUrl,
      email: auth.email,
      isLocalUser: true,
    );

    ref.read(authControllerProvider.notifier).updateStudyPreferences(
          level: level,
          medium: medium,
          username: me.username,
          province: province.name,
          bio: me.bio,
          headline: me.headline,
        );

    _replaceMe(me, persist: true);
    await SupabaseSync.upsertProfile(me);
    return null;
  }

  Future<String?> updateMyProfile({
    String? displayName,
    String? username,
    SriLankaProvince? province,
    String? bio,
    String? headline,
    String? avatarUrl,
    String? level,
    String? medium,
  }) async {
    final current = state.me;
    if (current == null) return 'Create a username first.';

    var nextUsername = current.username;
    if (username != null && username.trim().toLowerCase() != current.username) {
      final error = validateUsername(username, exceptUserId: current.id);
      if (error != null) return error;
      nextUsername = username.trim().toLowerCase();
    }

    final updated = current.copyWith(
      displayName: displayName?.trim().isEmpty == true
          ? current.displayName
          : (displayName?.trim() ?? current.displayName),
      username: nextUsername,
      province: province ?? current.province,
      bio: bio ?? current.bio,
      headline: headline ?? current.headline,
      avatarUrl: avatarUrl ?? current.avatarUrl,
      level: level ?? current.level,
      medium: medium ?? current.medium,
    );

    ref.read(authControllerProvider.notifier).updateProfileDetails(
          name: updated.displayName,
          username: updated.username,
          province: updated.province.name,
          bio: updated.bio,
          headline: updated.headline,
          avatarUrl: updated.avatarUrl,
          level: updated.level,
          medium: updated.medium,
        );

    _replaceMe(updated, persist: true);
    await SupabaseSync.upsertProfile(updated);
    return null;
  }

  PublicStudent? byUsername(String username) {
    final key = username.trim().toLowerCase();
    for (final s in state.students) {
      if (s.username == key) return s;
    }
    return null;
  }

  PublicStudent? byId(String id) {
    for (final s in state.students) {
      if (s.id == id) return s;
    }
    return null;
  }

  List<PublicStudent> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final hits = state.students.where((s) {
      return s.username.contains(q) ||
          s.displayName.toLowerCase().contains(q) ||
          s.headline.toLowerCase().contains(q) ||
          s.province.shortLabel.toLowerCase().contains(q);
    }).toList()
      ..sort((a, b) {
        final aExact = a.username == q ? 0 : 1;
        final bExact = b.username == q ? 0 : 1;
        if (aExact != bExact) return aExact.compareTo(bExact);
        return b.coins.compareTo(a.coins);
      });
    return hits;
  }

  List<PublicStudent> rankings({SriLankaProvince? province}) {
    final list = [
      for (final s in state.students)
        if (province == null || s.province == province) s,
    ]..sort((a, b) => b.coins.compareTo(a.coins));
    return list;
  }

  int nationalRankOf(String userId) {
    final list = rankings();
    final i = list.indexWhere((s) => s.id == userId);
    return i < 0 ? 0 : i + 1;
  }

  int provinceRankOf(String userId, SriLankaProvince province) {
    final list = rankings(province: province);
    final i = list.indexWhere((s) => s.id == userId);
    return i < 0 ? 0 : i + 1;
  }

  ConnectionStatus connectionStatus(String otherUserId) {
    final me = state.me;
    if (me == null || me.id == otherUserId) return ConnectionStatus.none;

    for (final c in state.connections) {
      if (c.status == 'accepted' &&
          ((c.fromUserId == me.id && c.toUserId == otherUserId) ||
              (c.fromUserId == otherUserId && c.toUserId == me.id))) {
        return ConnectionStatus.connected;
      }
      if (c.status == 'pending') {
        if (c.fromUserId == me.id && c.toUserId == otherUserId) {
          return ConnectionStatus.pendingOutgoing;
        }
        if (c.fromUserId == otherUserId && c.toUserId == me.id) {
          return ConnectionStatus.pendingIncoming;
        }
      }
    }
    return ConnectionStatus.none;
  }

  List<PublicStudent> myConnections() {
    final me = state.me;
    if (me == null) return const [];
    final ids = <String>{};
    for (final c in state.connections) {
      if (c.status != 'accepted') continue;
      if (c.fromUserId == me.id) ids.add(c.toUserId);
      if (c.toUserId == me.id) ids.add(c.fromUserId);
    }
    return [
      for (final id in ids)
        if (byId(id) != null) byId(id)!,
    ]..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  List<PublicStudent> incomingRequests() {
    final me = state.me;
    if (me == null) return const [];
    return [
      for (final c in state.connections)
        if (c.status == 'pending' && c.toUserId == me.id)
          if (byId(c.fromUserId) != null) byId(c.fromUserId)!,
    ];
  }

  Future<void> sendConnectionRequest(String toUserId) async {
    final me = state.me;
    if (me == null || me.id == toUserId) return;
    if (connectionStatus(toUserId) != ConnectionStatus.none) return;

    final conn = StudentConnection(
      fromUserId: me.id,
      toUserId: toUserId,
      status: 'pending',
      createdAt: DateTime.now(),
    );
    state = state.copyWith(connections: [...state.connections, conn]);
    await _persist();
    await SupabaseSync.upsertConnection(conn);
  }

  Future<void> acceptConnection(String fromUserId) async {
    final me = state.me;
    if (me == null) return;
    StudentConnection? accepted;
    final next = <StudentConnection>[];
    for (final c in state.connections) {
      if (c.fromUserId == fromUserId &&
          c.toUserId == me.id &&
          c.status == 'pending') {
        accepted = StudentConnection(
          fromUserId: c.fromUserId,
          toUserId: c.toUserId,
          status: 'accepted',
          createdAt: c.createdAt,
        );
        next.add(accepted);
      } else {
        next.add(c);
      }
    }
    state = state.copyWith(connections: next);
    await _persist();
    if (accepted != null) {
      await SupabaseSync.upsertConnection(accepted);
    }
  }

  Future<void> removeConnection(String otherUserId) async {
    final me = state.me;
    if (me == null) return;
    final next = [
      for (final c in state.connections)
        if (!((c.fromUserId == me.id && c.toUserId == otherUserId) ||
            (c.fromUserId == otherUserId && c.toUserId == me.id)))
          c,
    ];
    state = state.copyWith(connections: next);
    await _persist();
    await SupabaseSync.deleteConnection(me.id, otherUserId);
  }
}
