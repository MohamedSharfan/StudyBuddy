# Deployment and Testing

## Mobile

Generate native platform folders after Flutter is installed:

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

Production builds:

```bash
flutter build appbundle --release
flutter build ipa --release
```

Use `--dart-define` or CI secrets for Supabase and API configuration. Never commit real API keys.

## Backend

The planned NestJS API can be hosted on Railway, Render, or Azure App Service. Required environment values:

- `SUPABASE_URL`
- `SUPABASE_JWT_SECRET`
- `SUPABASE_SERVICE_ROLE_KEY`
- `DATABASE_URL`
- `OPENAI_API_KEY` or `GEMINI_API_KEY`
- `RATE_LIMIT_TTL`
- `RATE_LIMIT_MAX`

## Admin

The Next.js CMS lives in `admin/` and can be hosted on Vercel with the same API base URL and Supabase auth configuration.

Production checks:

```bash
cd admin
npm install
npm run build
```

## Phase 6 Verification

- Confirm the admin dashboard loads the curriculum, queue, and release sections without console errors.
- Confirm dashboard data is aligned with `/admin/dashboard`, `/admin/content`, and `/admin/workflow` response shapes.
- Confirm the CMS keeps its content and knowledge workflows separate from the student-facing mobile app.

## Phase 7 Verification

- Run backend unit tests for admin CMS rules and reward logic.
- Run Flutter tests for gamification and quiz session state.
- Build the Next.js admin app before release.
- Build the Flutter mobile app for release targets before deploying.

## Testing Strategy

- Unit tests for repositories, Riverpod controllers, DTO validators, and gamification rules.
- Widget tests for auth, onboarding, dashboard, subject detail, notes, and flashcards.
- Widget tests for quiz answer states, quiz completion, AI Panda messages, reward shop, profile, and leaderboard.
- API integration tests for Supabase JWT validation and content retrieval.
- API integration tests for quiz scoring, progress updates, coin ledger idempotency, achievement unlocks, and AI rate limits.
- Contract tests between Flutter models and NestJS response DTOs.
- RAG evaluation tests with syllabus-grounded expected answers before AI Panda ships.
- Admin CMS service tests for dashboard summaries, content creation, and knowledge embedding flows.
