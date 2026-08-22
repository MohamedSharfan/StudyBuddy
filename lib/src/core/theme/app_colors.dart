import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  /// Cool premium violet — deeper and more blue-leaning than warm purple.
  static const royalPurple = Color(0xFF5B21B6);
  static const electricPurple = Color(0xFF7C3AED);
  static const coolViolet = Color(0xFF8B5CF6);
  static const softLilac = Color(0xFFC4B5FD);
  static const lavender = Color(0xFFEDE9FE);
  static const mist = Color(0xFFF5F3FF);
  static const midnight = Color(0xFF0F0724);
  static const darkBackground = Color(0xFF12082B);
  static const darkCard = Color(0xFF1E103F);
  static const gold = Color(0xFFFBBF24);
  static const neonCyan = Color(0xFF22D3EE);
  static const progressGreen = Color(0xFF34D399);
  static const streakOrange = Color(0xFFFB923C);
  static const ink = Color(0xFF150B2E);
  
  // Dark purple theme colors matching the reference design
  static const deepSpacePurple = Color(0xFF0D0221); // Very dark purple background
  static const darkPurple = Color(0xFF1A0B2E); // Dark card background
  static const mediumPurple = Color(0xFF2D1B4E); // Medium purple for cards
  static const vibrantPurple = Color(0xFF7B2CBF); // Vibrant purple for buttons
  static const brightPurple = Color(0xFF9D4EDD); // Bright purple accents
  static const neonPurple = Color(0xFFA855F7); // Neon purple highlights
  static const goldenYellow = Color(0xFFFBBF24); // Gold for coins/rewards
  
  // Vibrant purple-themed colors for gamification
  static const brightPink = Color(0xFFEC4899);
  static const vibrantOrange = Color(0xFFFF6B35);
  static const sunnyYellow = Color(0xFFFCD34D);
  static const mintGreen = Color(0xFF10B981);
  static const skyBlue = Color(0xFF3B82F6);
  static const coral = Color(0xFFFF6B9D);
  static const turquoise = Color(0xFF14B8A6);
  static const deepPurple = Color(0xFF6B21A8);
  static const magentaPurple = Color(0xFFD946EF);
  static const indigoPurple = Color(0xFF6366F1);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4C1D95),
      Color(0xFF6D28D9),
      Color(0xFF7C3AED),
    ],
  );

  static const pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D0221), // Deep space purple
      Color(0xFF1A0B2E), // Dark purple
      Color(0xFF0D0221), // Back to deep space
    ],
  );
  
  // Dark space theme gradients matching reference design
  static const darkSpaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D0221), // Deep space purple
      Color(0xFF1A0B2E), // Dark purple
      Color(0xFF0D0221), // Back to deep space
    ],
  );
  
  static const darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2D1B4E), // Medium purple
      Color(0xFF1A0B2E), // Dark purple
    ],
  );
  
  static const vibrantCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7B2CBF), // Vibrant purple
      Color(0xFF9D4EDD), // Bright purple
    ],
  );
  
  static const magicBookGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B9D), // Pink
      Color(0xFFFFA500), // Orange
      Color(0xFFFFD700), // Gold
    ],
  );
  
  // Purple-centric vibrant gradients for gamification
  static const purpleHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6B21A8), // Deep purple
      Color(0xFF8B5CF6), // Cool violet
      Color(0xFFA855F7), // Purple
    ],
  );
  
  static const purplePinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B5CF6), // Cool violet
      Color(0xFFD946EF), // Magenta purple
      Color(0xFFEC4899), // Bright pink
    ],
  );
  
  static const purpleBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1), // Indigo
      Color(0xFF8B5CF6), // Cool violet
      Color(0xFF7C3AED), // Electric purple
    ],
  );
  
  static const purpleGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED), // Electric purple
      Color(0xFFA855F7), // Purple
      Color(0xFFFBBF24), // Gold
    ],
  );
  
  static const purpleGreenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B5CF6), // Cool violet
      Color(0xFF6366F1), // Indigo
      Color(0xFF10B981), // Mint green
    ],
  );
  
  static const purpleCyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED), // Electric purple
      Color(0xFF8B5CF6), // Cool violet
      Color(0xFF22D3EE), // Neon cyan
    ],
  );
  
  static const sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFFFD93D),
      Color(0xFFFBBF24),
    ],
  );
  
  static const oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF14B8A6),
      Color(0xFF10B981),
    ],
  );
  
  static const candyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEC4899),
      Color(0xFF8B5CF6),
      Color(0xFF6366F1),
    ],
  );
  
  static const fireGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFEC4899),
      Color(0xFF8B5CF6),
    ],
  );
  
  static const vibrantPageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [
      Color(0xFFFFF1F2),
      Color(0xFFF3E8FF),
      Color(0xFFDCFCE7),
    ],
  );
  
  // Purple-themed page gradient
  static const purplePageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [
      Color(0xFFF3E8FF), // Light lavender
      Color(0xFFEDE9FE), // Lavender
      Color(0xFFFAF5FF), // Very light purple
    ],
  );
}
