# StudyBuddy

AI-powered education companion for Sri Lankan O/L and A/L students.

This repository currently contains Phase 1 through Phase 5 mobile foundations:

- Flutter app shell with clean feature-first architecture.
- Riverpod state management and GoRouter navigation.
- Purple premium StudyBuddy design system.
- Splash, sign-in, and onboarding flow.
- Home dashboard with streak, coins, rank, continue-learning, and subjects.
- Subject detail, chapter overview, lesson notes, and flip flashcards.
- Quiz flow with answer feedback, scoring, and completion rewards.
- Progress and gamification state for coins, XP, ranks, streaks, achievements, leaderboard, and reward shop.
- AI Panda chat flow with backend-ready Dio service boundary and local syllabus-grounded fallback answers.
- Supabase/Dio/Isar dependencies prepared for production integration.

Phase 6 and 7 are now wired in as well:

- Next.js admin CMS with premium content operations UI.
- Backend admin analytics and workflow endpoints.
- Backend Jest test scaffolding for admin CMS flows.
- Premium gamified dashboard, profile, and quiz presentation updates.
- Deployment and testing guidance for mobile, backend, and admin.

## Setup

Mobile:

Install Flutter, then run:

```bash
flutter create --platforms=android,ios .
flutter pub get
copy .env.example .env
# Put your Supabase + Google keys in .env (gitignored)
flutter run
```

The app can run without Supabase values during early UI development. In that mode it uses seeded local learning content and **Explore demo**.

For real Gmail login, fill `.env` and follow **[Supabase + Google login setup](docs/supabase-google-login.md)**.

For production (saved progress, profiles, rankings across devices), run the SQL in **[Production setup](docs/production-setup.md)**.

Backend:

```bash
cd backend
npm install
npm run start:dev
```

Copy `backend/.env.example` to `backend/.env` and keep AI provider keys only in the backend environment.

Admin:

```bash
cd admin
npm install
npm run dev
```

## Docs

- [Architecture](docs/architecture.md)
- [API Design](docs/api-design.md)
- [Database Schema](docs/database-schema.sql)
- [Deployment and Testing](docs/deployment-testing.md)
- [Supabase Google Login](docs/supabase-google-login.md)
