# Production setup — StudyBuddy

## 1. Run database schema (required for cloud sync)

1. Open [Supabase Dashboard](https://supabase.com/dashboard) → your project → **SQL Editor**
2. Paste and run: [`docs/supabase-production.sql`](supabase-production.sql)
3. Confirm tables exist: `profiles`, `user_lesson_completions`, `user_quiz_completions`, `user_flashcard_completions`, `student_connections`

Until this runs, the app still works offline with **local device storage**. After it runs, Google-signed users sync progress + profile across devices.

## 2. What is persisted

| Data | Local device | Supabase (after SQL) |
|------|--------------|----------------------|
| Lessons / quizzes / flashcards completed | Yes | Yes |
| Coins, streak, rank, badges | Yes | Yes |
| Username, province, bio, photo | Yes | Yes |
| Connections | Yes | Yes |
| Leaderboard of other students | Cloud profiles only | Yes |

## 3. First-time vs returning users

- **First login** → onboarding asks username + province once
- **Next launches** → splash restores profile automatically → home
- Progress never resets on restart

## 4. Env

Keep `.env` with real `SUPABASE_URL` (`https://….supabase.co`) and `SUPABASE_ANON_KEY`.
