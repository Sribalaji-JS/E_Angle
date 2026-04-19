import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF2C4A7C);
  static const Color primaryLight = Color(0xFF3D5FA0);
  static const Color accent = Color(0xFF4A7AAD);
  static const Color accent2 = Color(0xFF6B9FD4);
  static const Color bg = Color(0xFFF4F6F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF8F9FC);
  static const Color textMuted = Color(0xFF5A6A80);
  static const Color textLight = Color(0xFF8A97A8);
  static const Color success = Color(0xFF2D7A4F);
  static const Color successBg = Color(0xFFE8F5EE);
  static const Color warnBg = Color(0xFFFDF3DC);
  static const Color warnText = Color(0xFF7A5C1E);
  static const Color infoBg = Color(0xFFE8EEF8);
  static const Color deepDark = Color(0xFF1A2E52);
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2E52), Color(0xFF2C4A7C), Color(0xFF3D5FA0)],
  );
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C4A7C), Color(0xFF4A7AAD)],
  );
  static const LinearGradient aiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6B21A8), Color(0xFF4338CA)],
  );
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.outfitTextTheme(),
        scaffoldBackgroundColor: AppColors.bg,
        useMaterial3: true,
      );
}
