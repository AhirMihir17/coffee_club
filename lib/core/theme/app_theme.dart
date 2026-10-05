import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Coffee Signature Colors
  static const Color primaryCoffee = Color(0xFFC67C4E); // Warm Caramel / Mocha
  static const Color primaryDark = Color(0xFF8D4E28);
  static const Color espressoBlack = Color(0xFF121212); // Deep Espresso
  static const Color darkRoast = Color(0xFF1C1815); // Dark Roast Container
  static const Color cardDark = Color(0xFF231F1C); // Dark Card Surface
  static const Color creamWhite = Color(0xFFF9F5F0); // Warm milk foam / latte
  static const Color softBrown = Color(0xFFEDE0D4); // Soft beige accent
  static const Color goldenStar = Color(0xFFFBBE21); // Rating gold
  static const Color accentHeart = Color(0xFFED5151); // Favorite heart
  static const Color mutedTextLight = Color(0xFF9E9289);
  static const Color mutedTextDark = Color(0xFFA59B93);

  // Backwards-compatible theme tokens
  static const Color background = espressoBlack;
  static const Color surface = darkRoast;
  static const Color lightBackground = creamWhite;
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color accent = primaryCoffee;
  static const Color mint = Color(0xFFD4A373); // Soft caramel

  static ThemeData dark() {
    return _theme(
      brightness: Brightness.dark,
      backgroundColor: espressoBlack,
      surfaceColor: darkRoast,
      foregroundColor: Colors.white,
      mutedColor: mutedTextDark,
      fieldFillColor: Colors.white.withValues(alpha: 0.07),
      fieldBorderColor: Colors.white.withValues(alpha: 0.12),
    );
  }

  static ThemeData light() {
    return _theme(
      brightness: Brightness.light,
      backgroundColor: creamWhite,
      surfaceColor: lightSurface,
      foregroundColor: const Color(0xFF261912),
      mutedColor: const Color(0xFF7E726A),
      fieldFillColor: const Color(0xFFF2ECE5),
      fieldBorderColor: const Color(0xFFE5DDD5),
    );
  }

  static ThemeData _theme({
    required Brightness brightness,
    required Color backgroundColor,
    required Color surfaceColor,
    required Color foregroundColor,
    required Color mutedColor,
    required Color fieldFillColor,
    required Color fieldBorderColor,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryCoffee,
        secondary: const Color(0xFFD4A373),
        surface: surfaceColor,
        onSurface: foregroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        error: const Color(0xFFBA1A1A),
        onError: Colors.white,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.soraTextTheme(
        base.textTheme,
      ).apply(bodyColor: foregroundColor, displayColor: foregroundColor),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFillColor,
        hintStyle: TextStyle(color: mutedColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: fieldBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: fieldBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryCoffee, width: 1.6),
        ),
      ),
    );
  }

  static Color foreground(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color muted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? mutedTextDark
          : const Color(0xFF7E726A);
}
