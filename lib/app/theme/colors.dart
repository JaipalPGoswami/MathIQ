import 'package:flutter/material.dart';

class AppColors {
  // Vibrant, friendly palette tailored for kids
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueLight = Color(0xFFDBEAFE);

  static const Color sunnyYellow = Color(0xFFFBBF24);
  static const Color warmAmber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFEF3C7);

  static const Color mintGreen = Color(0xFF10B981);
  static const Color emeraldGreen = Color(0xFF059669);
  static const Color greenLight = Color(0xFFD1FAE5);

  static const Color coralPink = Color(0xFFF43F5E);
  static const Color roseSoft = Color(0xFFFDA4AF);
  static const Color pinkLight = Color(0xFFFFE4E6);

  static const Color grapePurple = Color(0xFF8B5CF6);
  static const Color purpleLight = Color(0xFFEDE9FE);

  static const Color orangeTangerine = Color(0xFFF97316);
  static const Color orangeLight = Color(0xFFFFEDD5);

  static const Color skyTeal = Color(0xFF06B6D4);
  static const Color tealLight = Color(0xFFCFFAFE);

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardSurface = Colors.white;
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);

  // Feedback
  static const Color success = Color(0xFF10B981);
  static const Color encouragement = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Grade Colors
  static Color colorForGrade(String grade) {
    final g = grade.toLowerCase();
    if (g.contains('kg')) return coralPink;
    if (g.contains('1')) return skyTeal;
    if (g.contains('2')) return warmAmber;
    return grapePurple;
  }
}
