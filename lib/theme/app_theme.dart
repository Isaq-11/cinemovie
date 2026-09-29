import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _darkSeed = Color(0xFF135BC7);
  static const _lightSeed = Color(0xFFBCBEC1);

  static ThemeData get dark => _build(_darkSeed, Brightness.dark);
  static ThemeData get light => _build(_lightSeed, Brightness.light);

  static ThemeData _build(Color seed, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );
    final shape12 = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    OutlineInputBorder borda(Color cor, [double largura = 0]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: largura == 0
              ? BorderSide.none
              : BorderSide(color: cor, width: largura),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: borda(scheme.outline),
        enabledBorder: borda(scheme.outline),
        focusedBorder: borda(scheme.primary, 2),
        errorBorder: borda(scheme.error, 1),
        focusedErrorBorder: borda(scheme.error, 2),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainer,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: shape12,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: shape12,
        ),
      ),
    );
  }
}
