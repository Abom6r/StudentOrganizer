import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF275EFE); // أزرق أساسي
  static const Color secondary = Color(0xFFFFC857); // أصفر ذهبي
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color lightBackground = Color(0xFFF5F7FB);
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xFF111827);
  static const Color textLight = Colors.white70;
  static const Color border = Color(0xFFE5E7EB);
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF2E5BFF),
      Color(0xFF6C63FF),
      Color(0xFFFFC857),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient softBackground = LinearGradient(
    colors: [
      Color(0xFFE3F2FD),
      Color(0xFFF5F7FB),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppShadows {
  static final List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 18,
      offset: const Offset(0, 10),
    ),
  ];
}

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto', // غيّرها لو عندك خط مخصص
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
