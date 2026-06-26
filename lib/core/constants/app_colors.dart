import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — Deep Forest Green
  static Color primary = const Color(0xFF005127);
  static Color onPrimary = const Color(0xFFFFFFFF);
  static Color primaryContainer = const Color(0xFF1B6B3A);
  static Color onPrimaryContainer = const Color(0xFF9AE9AB);
  static Color primaryFixed = const Color(0xFFA5F4B6);
  static Color primaryFixedDim = const Color(0xFF8AD89C);
  static Color surfaceTint = const Color(0xFF1C6C3B);

  // Secondary — Warm Gold
  static Color secondary = const Color(0xFF835500);
  static Color onSecondary = const Color(0xFFFFFFFF);
  static Color secondaryContainer = const Color(0xFFFEAE2C);
  static Color onSecondaryContainer = const Color(0xFF6B4500);
  static Color secondaryFixed = const Color(0xFFFFDDB4);
  static Color secondaryFixedDim = const Color(0xFFFFB955);

  // Tertiary — Rose
  static Color tertiary = const Color(0xFF782C39);
  static Color onTertiary = const Color(0xFFFFFFFF);
  static Color tertiaryContainer = const Color(0xFF964350);
  static Color onTertiaryContainer = const Color(0xFFFFCACF);

  // Background & Surface
  static Color background = const Color(0xFFF7FAF3);
  static Color onBackground = const Color(0xFF181D18);
  static Color surface = const Color(0xFFF7FAF3);
  static Color onSurface = const Color(0xFF181D18);
  static Color surfaceBright = const Color(0xFFF7FAF3);
  static Color surfaceDim = const Color(0xFFD7DBD4);
  static Color surfaceContainerLowest = const Color(0xFFFFFFFF);
  static Color surfaceContainerLow = const Color(0xFFF1F5ED);
  static Color surfaceContainer = const Color(0xFFEBEFE8);
  static Color surfaceContainerHigh = const Color(0xFFE6E9E2);
  static Color surfaceContainerHighest = const Color(0xFFE0E4DD);
  static Color surfaceVariant = const Color(0xFFE0E4DD);
  static Color onSurfaceVariant = const Color(0xFF404940);

  // Inverse
  static Color inverseSurface = const Color(0xFF2D322D);
  static Color inverseOnSurface = const Color(0xFFEEF2EB);
  static Color inversePrimary = const Color(0xFF8AD89C);

  // Error
  static Color error = const Color(0xFFBA1A1A);
  static Color onError = const Color(0xFFFFFFFF);
  static Color errorContainer = const Color(0xFFFFDAD6);
  static Color onErrorContainer = const Color(0xFF93000A);

  // Outline
  static Color outline = const Color(0xFF707A6F);
  static Color outlineVariant = const Color(0xFFBFC9BD);

  // Custom utility colors
  static Color starGold = const Color(0xFFFFB800);
  static Color successGreen = const Color(0xFF2E7D32);
  static Color warningAmber = const Color(0xFFF57C00);
  static Color infoBlue = const Color(0xFF1565C0);

  // Gradient helpers
  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryContainer, primary],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );

  static LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryContainer, secondaryFixedDim],
  );

  static void updateTheme(bool isDark) {
    if (isDark) {
      primary = const Color(0xFF003D1B);
      onPrimary = Colors.white;
      primaryContainer = const Color(0xFF003D1B);
      onPrimaryContainer = const Color(0xFFC7F3D6);
      primaryFixed = const Color(0xFF005127);
      primaryFixedDim = const Color(0xFF1B6B3A);
      surfaceTint = const Color(0xFF003D1B);
      
      secondary = const Color(0xFF5A3B00);
      onSecondary = const Color(0xFF3D2700);
      secondaryContainer = const Color(0xFF5A3B00);
      onSecondaryContainer = const Color(0xFFFFE0B3);
      secondaryFixed = const Color(0xFF835500);
      secondaryFixedDim = const Color(0xFF5A3B00);
      
      background = const Color(0xFF101411);
      onBackground = const Color(0xFFE2E3DF);
      surface = const Color(0xFF101411);
      onSurface = const Color(0xFFE2E3DF);
      surfaceBright = const Color(0xFF101411);
      surfaceDim = const Color(0xFF181C19);
      surfaceContainerLowest = const Color(0xFF0A0D0B);
      surfaceContainerLow = const Color(0xFF181C19);
      surfaceContainer = const Color(0xFF202521);
      surfaceContainerHigh = const Color(0xFF282D29);
      surfaceContainerHighest = const Color(0xFF333934);
      surfaceVariant = const Color(0xFF333934);
      onSurfaceVariant = const Color(0xFFC2C8C0);
      
      inverseSurface = const Color(0xFFE2E3DF);
      inverseOnSurface = const Color(0xFF101411);
      
      error = const Color(0xFFCF6679);
      onError = Colors.black;
      errorContainer = const Color(0xFF93000A);
      onErrorContainer = const Color(0xFFFFDAD6);
      
      outline = const Color(0xFF8C9389);
      outlineVariant = const Color(0xFF424940);
    } else {
      primary = const Color(0xFF005127);
      onPrimary = const Color(0xFFFFFFFF);
      primaryContainer = const Color(0xFF1B6B3A);
      onPrimaryContainer = const Color(0xFF9AE9AB);
      primaryFixed = const Color(0xFFA5F4B6);
      primaryFixedDim = const Color(0xFF8AD89C);
      surfaceTint = const Color(0xFF1C6C3B);
      
      secondary = const Color(0xFF835500);
      onSecondary = const Color(0xFFFFFFFF);
      secondaryContainer = const Color(0xFFFEAE2C);
      onSecondaryContainer = const Color(0xFF6B4500);
      secondaryFixed = const Color(0xFFFFDDB4);
      secondaryFixedDim = const Color(0xFFFFB955);
      
      background = const Color(0xFFF7FAF3);
      onBackground = const Color(0xFF181D18);
      surface = const Color(0xFFF7FAF3);
      onSurface = const Color(0xFF181D18);
      surfaceBright = const Color(0xFFF7FAF3);
      surfaceDim = const Color(0xFFD7DBD4);
      surfaceContainerLowest = const Color(0xFFFFFFFF);
      surfaceContainerLow = const Color(0xFFF1F5ED);
      surfaceContainer = const Color(0xFFEBEFE8);
      surfaceContainerHigh = const Color(0xFFE6E9E2);
      surfaceContainerHighest = const Color(0xFFE0E4DD);
      surfaceVariant = const Color(0xFFE0E4DD);
      onSurfaceVariant = const Color(0xFF404940);
      
      inverseSurface = const Color(0xFF2D322D);
      inverseOnSurface = const Color(0xFFEEF2EB);
      
      error = const Color(0xFFBA1A1A);
      onError = const Color(0xFFFFFFFF);
      errorContainer = const Color(0xFFFFDAD6);
      onErrorContainer = const Color(0xFF93000A);
      
      outline = const Color(0xFF707A6F);
      outlineVariant = const Color(0xFFBFC9BD);
    }

    primaryGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryContainer, primary],
    );

    goldGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [secondaryContainer, secondaryFixedDim],
    );
  }
}
