import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppEnvironment {
  const AppEnvironment._();

  /// Must match `android/app/build.gradle.kts` → `applicationId`.
  static const androidApplicationId = 'com.example.studybuddy';

  static String get supabaseUrl => _normalizeSupabaseUrl(_read('SUPABASE_URL'));
  static String get supabaseAnonKey => _read('SUPABASE_ANON_KEY');
  static String get googleWebClientId => _read('GOOGLE_WEB_CLIENT_ID');
  static String get googleAndroidClientId => _read('GOOGLE_ANDROID_CLIENT_ID');
  static String get googleIosClientId => _read('GOOGLE_IOS_CLIENT_ID');
  static String get apiBaseUrl => _read(
        'API_BASE_URL',
        fallback: 'http://localhost:3000/api/v1',
      );

  static bool get isSupabaseReady =>
      _isValidSupabaseUrl(supabaseUrl) && _isRealValue(supabaseAnonKey);

  static String get supabaseConfigHint {
    final rawUrl = _read('SUPABASE_URL');
    if (!_isRealValue(rawUrl)) {
      return 'Add SUPABASE_URL to .env. Example: https://abcdefgh.supabase.co';
    }
    if (!_isValidSupabaseUrl(supabaseUrl)) {
      return 'SUPABASE_URL is wrong. It must be your project URL like '
          'https://YOUR_PROJECT_REF.supabase.co — not an API key. '
          'You currently have a key/token in SUPABASE_URL '
          '(values starting with sb_publishable_ / sb-publishable_ / eyJ belong in SUPABASE_ANON_KEY). '
          'Copy Project URL from Supabase → Project Settings → API.';
    }
    if (!_isRealValue(supabaseAnonKey)) {
      return 'Add SUPABASE_ANON_KEY to .env (anon public / publishable key from Supabase API settings).';
    }
    return 'Supabase is not configured. See docs/supabase-google-login.md';
  }

  static String _normalizeSupabaseUrl(String value) {
    var url = value.trim();
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  static bool _isValidSupabaseUrl(String value) {
    if (!_isRealValue(value)) {
      return false;
    }
    final lower = value.toLowerCase();
    // Common mix-up: putting the publishable/anon key into SUPABASE_URL.
    if (lower.startsWith('sb_publishable') ||
        lower.startsWith('sb-publishable') ||
        lower.startsWith('eyj') ||
        !lower.startsWith('http')) {
      return false;
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return false;
    }
    return uri.isScheme('https') || uri.isScheme('http');
  }

  /// Web client ID is always required (used as `serverClientId` for ID tokens).
  /// On Android / iOS the matching native client ID must also be set.
  static bool get isGoogleSignInReady {
    if (!_isRealValue(googleWebClientId)) {
      return false;
    }
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _isRealValue(googleAndroidClientId);
      case TargetPlatform.iOS:
        return _isRealValue(googleIosClientId);
      default:
        return true;
    }
  }

  /// Rejects empty values and leftover `.env.example` placeholders like
  /// `your-web-client-id.apps.googleusercontent.com`.
  static bool _isRealValue(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return false;
    }
    final lower = trimmed.toLowerCase();
    if (lower.startsWith('your-') ||
        lower.contains('your_project') ||
        lower.contains('your-project') ||
        lower.contains('changeme') ||
        lower.contains('example.com') && lower.contains('your')) {
      return false;
    }
    return true;
  }

  static String get googleSignInMissingHint {
    if (!_isRealValue(googleWebClientId)) {
      return 'GOOGLE_WEB_CLIENT_ID in .env is missing or still a placeholder. '
          'Create a Web OAuth client in Google Cloud and paste its Client ID '
          '(not the Android client ID).';
    }
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        !_isRealValue(googleAndroidClientId)) {
      return 'Add a real GOOGLE_ANDROID_CLIENT_ID to .env '
          '(Android OAuth client for $androidApplicationId + SHA-1).';
    }
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.iOS &&
        !_isRealValue(googleIosClientId)) {
      return 'Add a real GOOGLE_IOS_CLIENT_ID to your .env file.';
    }
    return 'Google sign-in is not fully configured. See docs/supabase-google-login.md';
  }

  /// Native OAuth client for the current platform.
  /// Android resolves via package name + SHA-1 in Google Cloud; we still
  /// keep `GOOGLE_ANDROID_CLIENT_ID` in config for a complete setup checklist.
  /// iOS needs `clientId` passed into `GoogleSignIn.initialize`.
  static String? get googleNativeClientId {
    if (kIsWeb) {
      return null;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return _isRealValue(googleIosClientId) ? googleIosClientId : null;
      case TargetPlatform.android:
        // Play Services matches the Android OAuth client by package + SHA-1.
        return null;
      default:
        return null;
    }
  }

  /// Prefer `.env` (gitignored). Falls back to `--dart-define` / `.env.example`.
  static Future<void> bootstrap() async {
    await _loadDotEnv();

    if (!isSupabaseReady) {
      return;
    }

    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  }

  static Future<void> _loadDotEnv() async {
    try {
      await dotenv.load(fileName: '.env', isOptional: true);
    } catch (_) {
      // Missing asset or parse issues — try example / dart-defines next.
    }

    if (!_hasCoreKeys) {
      try {
        await dotenv.load(fileName: '.env.example', isOptional: true);
      } catch (_) {
        // Offline / demo mode without env files.
      }
    }
  }

  static bool get _hasCoreKeys =>
      _read('SUPABASE_URL').isNotEmpty ||
      _read('GOOGLE_WEB_CLIENT_ID').isNotEmpty;

  /// Reads `.env` first, then compile-time `--dart-define` overrides.
  static String _read(String key, {String fallback = ''}) {
    if (dotenv.isInitialized) {
      final fromFile = dotenv.maybeGet(key)?.trim();
      if (fromFile != null && fromFile.isNotEmpty) {
        return fromFile;
      }
    }

    return String.fromEnvironment(key, defaultValue: fallback);
  }
}
