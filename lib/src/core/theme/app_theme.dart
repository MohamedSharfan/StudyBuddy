import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.electricPurple,
        primary: AppColors.royalPurple,
        secondary: AppColors.coolViolet,
        tertiary: AppColors.neonCyan,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.deepSpacePurple,
      textTheme: textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: const Color(0xFF2D1B4E).withValues(alpha: 0.7),
        elevation: 0,
        indicatorColor: const Color(0xFF7B2CBF).withValues(alpha: 0.3),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF9D4EDD), size: 24);
          }
          return IconThemeData(
            color: Colors.white.withValues(alpha: 0.6),
            size: 24,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      visualDensity: VisualDensity.comfortable,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.royalPurple,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(46),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              const BorderSide(color: AppColors.electricPurple, width: 1.4),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final textTheme =
        GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.coolViolet,
        brightness: Brightness.dark,
        primary: AppColors.coolViolet,
        secondary: AppColors.gold,
        tertiary: AppColors.neonCyan,
        surface: AppColors.darkCard,
      ),
      scaffoldBackgroundColor: AppColors.deepSpacePurple,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: const Color(0xFF2D1B4E).withValues(alpha: 0.7),
        elevation: 0,
        indicatorColor: const Color(0xFF7B2CBF).withValues(alpha: 0.3),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF9D4EDD), size: 24);
          }
          return IconThemeData(
            color: Colors.white.withValues(alpha: 0.6),
            size: 24,
          );
        }),
      ),
    );
  }
}
