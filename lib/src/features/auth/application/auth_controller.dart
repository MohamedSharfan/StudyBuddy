import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_environment.dart';
import '../domain/student_profile.dart';

final authControllerProvider =
    NotifierProvider<AuthController, StudentProfile?>(AuthController.new);

final authBusyProvider = StateProvider<bool>((ref) => false);
final authErrorProvider = StateProvider<String?>((ref) => null);

class AuthController extends Notifier<StudentProfile?> {
  @override
  StudentProfile? build() {
    if (!AppEnvironment.isSupabaseReady) {
      return null;
    }

    final client = Supabase.instance.client;
    final sub = client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (user == null) {
        state = null;
        return;
      }
      final next = _profileFromUser(user);
      final prev = state;
      // Preserve social fields claimed in-app (username/province/bio).
      state = prev == null || prev.id != next.id
          ? next
          : next.copyWith(
              username: prev.username,
              province: prev.province,
              bio: prev.bio,
              headline: prev.headline,
              level: prev.level,
              medium: prev.medium,
              avatarUrl: next.avatarUrl ?? prev.avatarUrl,
              name: next.name.isNotEmpty ? next.name : prev.name,
            );
    });
    ref.onDispose(sub.cancel);

    final session = client.auth.currentSession;
    if (session != null) {
      return _profileFromUser(session.user);
    }
    return null;
  }

  bool get isSupabaseReady => AppEnvironment.isSupabaseReady;

  void continueAsDemoStudent({
    String level = 'O/L',
    String medium = 'Tamil',
  }) {
    state = StudentProfile(
      id: 'demo-student',
      name: 'Student',
      level: level,
      medium: medium,
      coins: 0,
      streakDays: 0,
      rank: 'Bronze',
      email: 'demo@studybuddy.lk',
    );
  }

  /// Keeps Google / existing identity; updates study + social profile fields.
  void updateStudyPreferences({
    required String level,
    required String medium,
    String? username,
    String? province,
    String? bio,
    String? headline,
  }) {
    final current = state;
    if (current == null) {
      continueAsDemoStudent(level: level, medium: medium);
      state = state!.copyWith(
        username: username,
        province: province,
        bio: bio,
        headline: headline,
      );
      return;
    }
    state = current.copyWith(
      level: level,
      medium: medium,
      username: username,
      province: province,
      bio: bio,
      headline: headline,
    );
  }

  void updateProfileDetails({
    String? name,
    String? username,
    String? province,
    String? bio,
    String? headline,
    String? avatarUrl,
    String? level,
    String? medium,
  }) {
    final current = state;
    if (current == null) return;
    state = current.copyWith(
      name: name,
      username: username,
      province: province,
      bio: bio,
      headline: headline,
      avatarUrl: avatarUrl,
      level: level,
      medium: medium,
    );
  }

  /// Native Google sign-in → Supabase session via ID token.
  Future<bool> signInWithGoogle() async {
    ref.read(authErrorProvider.notifier).state = null;

    if (!AppEnvironment.isSupabaseReady) {
      ref.read(authErrorProvider.notifier).state =
          AppEnvironment.supabaseConfigHint;
      return false;
    }

    if (!AppEnvironment.isGoogleSignInReady) {
      ref.read(authErrorProvider.notifier).state =
          AppEnvironment.googleSignInMissingHint;
      return false;
    }

    ref.read(authBusyProvider.notifier).state = true;
    try {
      const scopes = ['email', 'profile'];
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        // Web client ID — required so Google returns an ID token Supabase accepts.
        serverClientId: AppEnvironment.googleWebClientId,
        // iOS native client. Android uses package name + SHA-1 (see docs).
        clientId: AppEnvironment.googleNativeClientId,
      );

      GoogleSignInAccount? googleUser =
          await googleSignIn.attemptLightweightAuthentication();
      googleUser ??= await googleSignIn.authenticate();

      final authorization =
          await googleUser.authorizationClient.authorizationForScopes(scopes) ??
              await googleUser.authorizationClient.authorizeScopes(scopes);

      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw const AuthException('No Google ID token returned.');
      }

      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('Supabase did not return a user.');
      }

      state = _profileFromUser(user);
      return true;
    } on GoogleSignInException catch (error) {
      ref.read(authErrorProvider.notifier).state =
          _googleSignInHint(error);
      return false;
    } on AuthException catch (error) {
      ref.read(authErrorProvider.notifier).state = error.message;
      return false;
    } catch (error) {
      final text = error.toString();
      if (text.contains('Developer console') || text.contains('28444')) {
        ref.read(authErrorProvider.notifier).state = _developerConsoleHint;
        return false;
      }
      ref.read(authErrorProvider.notifier).state = text;
      return false;
    } finally {
      ref.read(authBusyProvider.notifier).state = false;
    }
  }

  static const _developerConsoleHint =
      'Google Developer Console is not set up correctly.\n\n'
      '1) GOOGLE_WEB_CLIENT_ID in .env must be the Web OAuth client ID '
      '(not Android/iOS) from Google Cloud.\n'
      '2) Android OAuth client package must be com.example.studybuddy.\n'
      '3) Add this debug SHA-1 to that Android client:\n'
      '   B3:4B:68:56:55:CC:B0:97:3B:0C:17:12:84:F2:E6:CC:3C:CA:7F:0A\n'
      '4) Paste the same Web client ID + secret into Supabase → Auth → Google.\n'
      '5) Full restart the app after editing .env.';

  static String _googleSignInHint(GoogleSignInException error) {
    final detail = '${error.code} ${error.description ?? ''}';
    if (detail.contains('Developer console') ||
        detail.contains('28444') ||
        detail.contains('unknownError')) {
      return _developerConsoleHint;
    }
    return error.description ?? error.toString();
  }

  Future<void> signOut() async {
    if (AppEnvironment.isSupabaseReady) {
      await Supabase.instance.client.auth.signOut();
    }
    state = null;
  }

  StudentProfile _profileFromUser(User user) {
    final meta = user.userMetadata ?? {};
    final fullName = (meta['full_name'] ??
            meta['name'] ??
            user.email?.split('@').first ??
            'Student')
        .toString();
    final avatar = meta['avatar_url']?.toString() ?? meta['picture']?.toString();

    return StudentProfile(
      id: user.id,
      name: fullName,
      level: 'O/L',
      medium: 'Tamil',
      coins: 0,
      streakDays: 0,
      rank: 'Bronze',
      email: user.email,
      avatarUrl: avatar,
    );
  }
}
