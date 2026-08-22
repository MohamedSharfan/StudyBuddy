# Supabase + Gmail login for StudyBuddy

This guide connects Flutter StudyBuddy to Supabase Auth with Google (Gmail), including **Android**.

## Quick start (recommended)

1. Copy the example env file (once):

```powershell
copy .env.example .env
```

2. Put your real keys in **`.env`** (already gitignored — will not be pushed to GitHub).

3. Run normally:

```powershell
flutter run
```

No `--dart-define` flags needed. The app loads `.env` at startup via `flutter_dotenv`.

## Env vars checklist

| Variable | Where from | Required |
|----------|------------|----------|
| `SUPABASE_URL` | Supabase → Project Settings → API | Yes |
| `SUPABASE_ANON_KEY` | Supabase → Project Settings → API (anon public) | Yes |
| `GOOGLE_WEB_CLIENT_ID` | Google Cloud → OAuth client type **Web** | Yes (used as `serverClientId` for ID tokens) |
| `GOOGLE_ANDROID_CLIENT_ID` | Google Cloud → OAuth client type **Android** | Yes on Android |
| `GOOGLE_IOS_CLIENT_ID` | Google Cloud → OAuth client type **iOS** | Yes on iOS |
| `API_BASE_URL` | Local backend | Optional |

Example `.env`:

```env
SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
GOOGLE_ANDROID_CLIENT_ID=YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=YOUR_IOS_CLIENT_ID.apps.googleusercontent.com
API_BASE_URL=http://localhost:3000/api/v1
```

**Important:** `SUPABASE_URL` must be the **Project URL** (`https://….supabase.co`).  
Never put `sb_publishable_…`, `sb-publishable_…`, or `eyJ…` keys in `SUPABASE_URL` — those belong in `SUPABASE_ANON_KEY`.

## 1. Create a Supabase project

1. Go to [https://supabase.com](https://supabase.com) and create a project.
2. Open **Project Settings → API**.
3. Copy:
   - **Project URL** → `SUPABASE_URL`
   - **anon public** key → `SUPABASE_ANON_KEY`

## 2. Enable Google provider in Supabase

1. In Supabase: **Authentication → Providers → Google**.
2. Turn Google **ON**.
3. Paste the Google Cloud **Web** Client ID + Client Secret.
4. Save. Callback URL is usually:
   `https://<PROJECT_REF>.supabase.co/auth/v1/callback`

## 3. Create Google OAuth credentials

1. Open [Google Cloud Console](https://console.cloud.google.com/).
2. Create (or select) a project.
3. Enable **Google People API** (APIs & Services → Library).
4. Configure the **OAuth consent screen** (External; add your Gmail as a test user while developing).
5. **APIs & Services → Credentials → Create credentials → OAuth client ID** — create **three** clients:

### A) Web application → `GOOGLE_WEB_CLIENT_ID`

- Type: **Web application**
- Authorized redirect URI: Supabase callback URL above
- Copy **Client ID** → `GOOGLE_WEB_CLIENT_ID`
- Copy **Client secret** → paste into Supabase Google provider

### B) Android → `GOOGLE_ANDROID_CLIENT_ID`

- Type: **Android**
- Package name: `com.example.studybuddy`  
  (must match `applicationId` in `android/app/build.gradle.kts`)
- SHA-1 certificate fingerprint: from your debug/release keystore (see below)
- Copy **Client ID** → `GOOGLE_ANDROID_CLIENT_ID`

Android Sign-In matches this client automatically via **package name + SHA-1**.

### C) iOS → `GOOGLE_IOS_CLIENT_ID` (when building for iPhone)

- Type: **iOS**
- Bundle ID: your iOS bundle identifier
- Copy **Client ID** → `GOOGLE_IOS_CLIENT_ID`

### Android SHA-1 (debug)

PowerShell from the repo root:

```powershell
cd android
.\gradlew signingReport
```

Or:

```powershell
keytool -list -v -alias androiddebugkey -keystore "$env:USERPROFILE\.android\debug.keystore" -storepass android -keypass android
```

Copy the `SHA1` value into the Android OAuth client in Google Cloud.

For release builds, also add the **release** keystore SHA-1.

## 4. What is already wired in this repo

| Piece | Status |
|-------|--------|
| Load secrets from `.env` | Wired (`flutter_dotenv` in `app_environment.dart`) |
| `google_sign_in` + Supabase `signInWithIdToken` | Wired in `auth_controller.dart` |
| Sign-in UI “Continue with Gmail” | Wired in `sign_in_page.dart` |
| Android `INTERNET` permission | Wired in `AndroidManifest.xml` |
| Android Play Services package queries | Wired in `AndroidManifest.xml` |
| Application ID | `com.example.studybuddy` |
| `.env` gitignored | Yes — will not be pushed |

## 5. Optional: `--dart-define` override

If you need CI or a one-off without editing `.env`, dart-defines still work and override empty `.env` values:

```powershell
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co
```

Day-to-day: prefer `.env` + plain `flutter run`.

## 6. What the app does

1. Student taps **Continue with Gmail**.
2. Native Google account picker opens (`google_sign_in`).
3. App sends Google ID token to Supabase (`signInWithIdToken`).
4. Supabase returns a session; StudyBuddy builds `StudentProfile`.

If keys are missing, the UI shows a clear error. **Explore demo** still works offline.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| **"No host specified in URI"** / `sb_publishable_…/auth/v1/token` | `SUPABASE_URL` is set to an API key. Fix: set `SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co` from Supabase → Settings → API → Project URL |
| Keys not loading | Confirm `.env` is in the project root; run a **full restart** (not just hot reload) |
| "Supabase is not configured" | Fill `SUPABASE_URL` + `SUPABASE_ANON_KEY` in `.env` |
| Missing Google client IDs | Fill `GOOGLE_WEB_CLIENT_ID` + `GOOGLE_ANDROID_CLIENT_ID` in `.env` |
| **`Developer console is not set up correctly` / `28444`** | Almost always: (1) `GOOGLE_WEB_CLIENT_ID` is still a placeholder or is the **Android** client ID by mistake — it must be the **Web** client ID; (2) Android client package/SHA-1 mismatch — use package `com.example.studybuddy` and debug SHA-1 `B3:4B:68:56:55:CC:B0:97:3B:0C:17:12:84:F2:E6:CC:3C:CA:7F:0A` |
| Google popup closes / `ApiException: 10` | Same as above — SHA-1 or package name mismatch |
| Supabase rejects token | Web client ID in `.env` must match Supabase Google provider |
| Accidental commit fear | `.env` is in `.gitignore` — only commit `.env.example` |

Official reference: [Supabase Login with Google (Flutter)](https://supabase.com/docs/guides/auth/social-login/auth-google?platform=flutter)
