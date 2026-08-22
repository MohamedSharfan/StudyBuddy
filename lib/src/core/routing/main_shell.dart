import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared chrome for Home / Ranks / Panda / Profile so the bottom bar stays.
class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  static int indexForLocation(String location) {
    if (location.startsWith('/leaderboard')) {
      return 1;
    }
    if (location.startsWith('/ai-panda')) {
      return 2;
    }
    if (location.startsWith('/profile') || location.startsWith('/rewards')) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = indexForLocation(location);

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B2CBF).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2D1B4E).withValues(alpha: 0.8),
                    const Color(0xFF1A0B2E).withValues(alpha: 0.9),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: NavigationBar(
                height: 70,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedIndex: selectedIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                indicatorColor: const Color(0xFF7B2CBF).withValues(alpha: 0.3),
                onDestinationSelected: (index) {
                  switch (index) {
                    case 0:
                      context.go('/home');
                    case 1:
                      context.go('/leaderboard');
                    case 2:
                      context.go('/ai-panda');
                    case 3:
                      context.go('/profile');
                  }
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined, size: 24),
                    selectedIcon: Icon(Icons.home_rounded, size: 24),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.leaderboard_outlined, size: 24),
                    selectedIcon: Icon(Icons.leaderboard_rounded, size: 24),
                    label: 'Ranks',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.smart_toy_outlined, size: 24),
                    selectedIcon: Icon(Icons.smart_toy_rounded, size: 24),
                    label: 'Panda',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded, size: 24),
                    selectedIcon: Icon(Icons.person_rounded, size: 24),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
