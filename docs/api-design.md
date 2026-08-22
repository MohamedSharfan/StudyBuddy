# StudyBuddy API Design

Base path: `/api/v1`

Authentication uses Supabase Auth JWTs. The NestJS API validates bearer tokens, maps the `sub` claim to `profiles.id`, and applies rate limits to auth-adjacent, quiz, and AI routes.

## Phase 1

| Method  | Route               | Purpose                                                         |
| ------- | ------------------- | --------------------------------------------------------------- |
| `GET`   | `/me`               | Current profile, rank, streak, coins, selected level and medium |
| `PATCH` | `/me`               | Update display name, avatar, level, medium                      |
| `GET`   | `/config/bootstrap` | App version, feature flags, supported grades and mediums        |

## Phase 2

| Method | Route                      | Purpose                                     |
| ------ | -------------------------- | ------------------------------------------- |
| `GET`  | `/subjects`                | Subjects for the student's grade and medium |
| `GET`  | `/subjects/:id`            | Subject detail with chapter progress        |
| `GET`  | `/chapters/:id`            | Chapter detail                              |
| `GET`  | `/chapters/:id/lessons`    | Published notes for a chapter               |
| `GET`  | `/lessons/:id`             | Full lesson note content                    |
| `POST` | `/lessons/:id/complete`    | Mark note read and award eligible coins     |
| `GET`  | `/chapters/:id/flashcards` | Flashcards for review                       |
| `POST` | `/flashcards/:id/review`   | Store review result for spaced repetition   |

## Phase 3

| Method | Route                        | Purpose                                            |
| ------ | ---------------------------- | -------------------------------------------------- |
| `POST` | `/quiz-attempts`             | Start a quiz attempt for a subject or chapter      |
| `POST` | `/quiz-attempts/:id/answers` | Submit one answer and receive correctness feedback |
| `POST` | `/quiz-attempts/:id/submit`  | Finish attempt, calculate score, update progress   |
| `GET`  | `/progress/summary`          | Overall, subject, and chapter progress             |
| `POST` | `/study-sessions`            | Record learning activity and study duration        |

## Phase 4

| Method | Route                 | Purpose                                   |
| ------ | --------------------- | ----------------------------------------- |
| `GET`  | `/coins`              | Current balance and recent coin ledger    |
| `GET`  | `/achievements`       | Achievement catalog and unlocked state    |
| `GET`  | `/leaderboards`       | Overall, subject, and friends leaderboard |
| `GET`  | `/ranks`              | Rank thresholds                           |
| `GET`  | `/rewards`            | Reward shop catalog                       |
| `POST` | `/rewards/:id/unlock` | Unlock cosmetic reward using coins        |

## Phase 5

| Method | Route                               | Purpose                                 |
| ------ | ----------------------------------- | --------------------------------------- |
| `GET`  | `/ai/conversations`                 | List AI Panda conversations             |
| `POST` | `/ai/conversations`                 | Create a conversation                   |
| `POST` | `/ai/conversations/:id/messages`    | Ask AI Panda with RAG retrieval         |
| `POST` | `/ai/knowledge-documents`           | Admin upload for syllabus/paper content |
| `POST` | `/ai/knowledge-documents/:id/embed` | Chunk and embed uploaded content        |

## Phase 6

| Method | Route                                  | Purpose                                                                |
| ------ | -------------------------------------- | ---------------------------------------------------------------------- |
| `GET`  | `/admin/dashboard`                     | Admin overview, live signals, curriculum health, and release readiness |
| `GET`  | `/admin/content`                       | CMS subject, lesson, and flashcard publishing queues                   |
| `GET`  | `/admin/workflow`                      | Editorial and AI embedding task board                                  |
| `POST` | `/admin/content`                       | Create new subject, lesson, flashcard, or quiz content                 |
| `POST` | `/admin/knowledge-documents`           | Upload syllabus or paper content for embedding                         |
| `POST` | `/admin/knowledge-documents/:id/embed` | Queue a document for vector embedding                                  |

## Future Modules

| Module    | Routes                                                                                |
| --------- | ------------------------------------------------------------------------------------- |
| Admin CMS | `/admin/dashboard`, `/admin/content`, `/admin/workflow`, `/admin/knowledge-documents` |

## NestJS Module Shape

- `AuthModule`: Supabase JWT guard, role guard, profile resolver.
- `UsersModule`: profile and preferences.
- `ContentModule`: subjects, chapters, lessons, flashcards, past papers.
- `ProgressModule`: lesson completion, study sessions, streak update.
- `GamificationModule`: coins, achievements, ranks, leaderboards.
- `AiModule`: RAG retrieval, prompt assembly, AI provider adapter.
- `AdminModule`: CMS APIs protected by admin role.

## AI Panda Backend Rule

The mobile app must call only StudyBuddy backend AI routes. OpenAI or Gemini keys stay on the server. The backend retrieves syllabus chunks from `knowledge_chunks`, injects only relevant context into the prompt, stores conversation messages, and returns a student-safe explanation with examples, exam tips, and practice questions.
