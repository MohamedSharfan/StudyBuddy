import 'package:flutter/material.dart';

import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';

class StudyBuddyApp extends StatelessWidget {
  const StudyBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final capped = media.copyWith(
      textScaler: TextScaler.linear(
        media.textScaler.scale(1).clamp(0.9, 1.12),
      ),
    );

    return MediaQuery(
      data: capped,
      child: MaterialApp.router(
        title: 'StudyBuddy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: appRouter,
      ),
    );
  }
}
