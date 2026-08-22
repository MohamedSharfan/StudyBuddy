# StudyBuddy Architecture

## Flutter

The mobile app follows feature-first clean architecture:

- `lib/src/core`: config, routing, theme, cross-cutting services.
- `lib/src/shared`: reusable UI components.
- `lib/src/features/auth`: splash, sign-in, onboarding, student session state.
- `lib/src/features/learning`: subjects, chapters, notes, and flashcards.
- `lib/src/features/quiz`: quiz session state, answer feedback, score results.
- `lib/src/features/gamification`: coins, XP, ranks, achievements, rewards, leaderboard, profile.
- `lib/src/features/ai`: AI Panda chat controller and backend-ready repository.

Riverpod owns app state and dependency injection. GoRouter owns all navigation. Dio, Supabase, and Isar are declared for production integration, but Phase 1/2 currently use a seeded repository so UI and navigation can be validated before the backend is connected.

## Backend

NestJS should use module boundaries that match product domains:

- `auth`: JWT validation and Supabase integration.
- `users`: profiles, preferences, avatars.
- `content`: subjects, chapters, notes, flashcards, past papers.
- `progress`: completion state, study sessions, streaks.
- `gamification`: coins, achievements, ranks.
- `ai`: RAG search, AI Panda conversation orchestration.
- `admin`: content management APIs.

The repository includes a starter NestJS API under `backend/` for Phase 3-5 routes. The services currently expose the right route contracts and safe boundaries; database persistence should be wired through Supabase/PostgreSQL repositories before production release.

## Local Offline Strategy

Isar should cache:

- Student profile and preferences.
- Subject and chapter metadata.
- Downloaded lesson notes and flashcards.
- Pending progress events for retry when offline.

Server data remains authoritative. The app should enqueue offline activity events and replay them through the API when connectivity returns.

## Phase 3-5 Flow

Quiz, flashcard, and lesson completion actions dispatch progress events to the gamification controller in the current mobile build. When the backend is connected, those events should be sent to NestJS first, then the app should reconcile the returned authoritative coin, XP, rank, streak, and achievement state.

AI Panda is separated behind `AiPandaRepository`. Today it can produce seeded local answers for development. In production it posts to the NestJS AI endpoint, where RAG retrieval and provider calls happen securely.

## Security

- Never store OpenAI or Gemini keys in Flutter.
- Validate Supabase JWTs in NestJS guards.
- Apply DTO validation with `class-validator`.
- Use row-level security in Supabase for direct user-owned data.
- Keep admin writes behind API role checks.
- Rate-limit AI and auth-sensitive endpoints.
