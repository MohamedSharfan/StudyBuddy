import 'package:go_router/go_router.dart';

import '../../features/ai/presentation/ai_panda_page.dart';
import '../../features/auth/presentation/onboarding_page.dart';
import '../../features/auth/presentation/sign_in_page.dart';
import '../../features/auth/presentation/splash_page.dart';
import '../../features/gamification/presentation/leaderboard_page.dart';
import '../../features/gamification/presentation/profile_page.dart';
import '../../features/gamification/presentation/rewards_page.dart';
import '../../features/learning/presentation/flashcards_page.dart';
import '../../features/learning/presentation/home_dashboard_page.dart';
import '../../features/learning/presentation/note_reader_page.dart';
import '../../features/learning/presentation/subject_detail_page.dart';
import '../../features/quiz/presentation/quiz_page.dart';
import '../../features/social/presentation/edit_profile_page.dart';
import '../../features/social/presentation/public_profile_page.dart';
import 'app_routes.dart';
import 'main_shell.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeDashboardPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.leaderboard,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LeaderboardPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.aiPanda,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AiPandaPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfilePage(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.subject,
      builder: (context, state) => SubjectDetailPage(
        subjectId: state.pathParameters['subjectId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.note,
      builder: (context, state) => NoteReaderPage(
        subjectId: state.pathParameters['subjectId']!,
        noteId: state.pathParameters['noteId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.flashcards,
      builder: (context, state) => FlashcardsPage(
        subjectId: state.pathParameters['subjectId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.quiz,
      builder: (context, state) => QuizPage(
        subjectId: state.pathParameters['subjectId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.rewards,
      builder: (context, state) => const RewardsPage(),
    ),
    GoRoute(
      path: AppRoutes.profileEdit,
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.publicProfile,
      builder: (context, state) => PublicProfilePage(
        username: state.pathParameters['username']!,
      ),
    ),
  ],
);
