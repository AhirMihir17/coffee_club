import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF070B18);
  static const Color surface = Color(0xFF12182B);
  static const Color lightBackground = Color(0xFFF5F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF7C8CFF);
  static const Color mint = Color(0xFF3EE0B2);

  static ThemeData dark() {
    return _theme(
      brightness: Brightness.dark,
      backgroundColor: background,
      surfaceColor: surface,
      foregroundColor: Colors.white,
      mutedColor: Colors.white.withValues(alpha: 0.62),
      fieldFillColor: Colors.white.withValues(alpha: 0.06),
      fieldBorderColor: Colors.white.withValues(alpha: 0.08),
    );
  }

  static ThemeData light() {
    return _theme(
      brightness: Brightness.light,
      backgroundColor: lightBackground,
      surfaceColor: lightSurface,
      foregroundColor: const Color(0xFF17203A),
      mutedColor: const Color(0xFF65708A),
      fieldFillColor: const Color(0xFFF0F2F8),
      fieldBorderColor: const Color(0xFFDCE1ED),
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
        primary: accent,
        secondary: mint,
        surface: surfaceColor,
        onSurface: foregroundColor,
        onPrimary: Colors.white,
        onSecondary: const Color(0xFF06251D),
        error: const Color(0xFFBA1A1A),
        onError: Colors.white,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(
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
          borderSide: const BorderSide(color: accent, width: 1.4),
        ),
      ),
    );
  }

  static Color foreground(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color muted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.62)
      : const Color(0xFF65708A);
}
