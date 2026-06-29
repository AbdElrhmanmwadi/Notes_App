import 'package:flutter/material.dart';

/// Centralised Material 3 theming. A single seed colour drives a harmonious
/// light and dark palette via [ColorScheme.fromSeed].
class AppTheme {
  AppTheme._();

  /// Default brand seed (amber, matches the FAB). Used when the user hasn't
  /// chosen a custom accent.
  static const Color defaultSeed = Color(0xFFFFB300);
  static const String _fontFamily = 'Roboto';

  static ThemeData light({Color? seed}) => _build(Brightness.light, seed);
  static ThemeData dark({Color? seed}) => _build(Brightness.dark, seed);

  static ThemeData _build(Brightness brightness, [Color? seed]) {
    final scheme = ColorScheme.fromSeed(
        seedColor: seed ?? defaultSeed, brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        prefixIconColor: scheme.onSurfaceVariant,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
