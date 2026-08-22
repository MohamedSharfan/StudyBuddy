class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const signIn = '/sign-in';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const subject = '/subjects/:subjectId';
  static const note = '/subjects/:subjectId/notes/:noteId';
  static const flashcards = '/subjects/:subjectId/flashcards';
  static const quiz = '/subjects/:subjectId/quiz';
  static const aiPanda = '/ai-panda';
  static const leaderboard = '/leaderboard';
  static const profile = '/profile';
  static const profileEdit = '/profile/edit';
  static const publicProfile = '/u/:username';
  static const rewards = '/rewards';
}
