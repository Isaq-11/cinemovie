import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _dark_theme = Color.fromARGB(255, 3, 37, 87); // vinho, troque à vontade
  static const _light_theme = Color.fromARGB(255, 188, 190, 193); // vinho, troque à vontade

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: _dark_theme,
      brightness: Brightness.dark,
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
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _light_theme,
      brightness: Brightness.light,
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
        ThemeData(brightness: Brightness.light).textTheme,
      ),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}