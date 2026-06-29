import 'dart:io';

import 'package:flutter/material.dart';

import '../app_paths.dart';

enum NoteBgType { none, solid, gradient, image }

/// A predefined gradient with a hint about which text colour reads best on it.
class NoteGradient {
  const NoteGradient(this.id, this.colors, this.brightness);

  final String id;
  final List<Color> colors;

  /// Brightness of the gradient surface (light => dark text, dark => light text).
  final Brightness brightness;

  LinearGradient get gradient => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

/// Describes a note's background (none / solid colour / gradient / photo) and
/// knows how to render itself *and* which text colours stay legible on top.
class NoteBackground {
  const NoteBackground._(this.type,
      {Color? color, NoteGradient? gradient, this.imageFile})
      : _color = color,
        _gradient = gradient;

  final NoteBgType type;
  final Color? _color;
  final NoteGradient? _gradient;
  final String? imageFile;

  static const NoteBackground none = NoteBackground._(NoteBgType.none);

  factory NoteBackground.solid(Color color) =>
      NoteBackground._(NoteBgType.solid, color: color);

  factory NoteBackground.gradient(NoteGradient g) =>
      NoteBackground._(NoteBgType.gradient, gradient: g);

  factory NoteBackground.image(String fileName) =>
      NoteBackground._(NoteBgType.image, imageFile: fileName);

  /// Curated solid colours (light pastels).
  static const List<Color> solidColors = [
    Color(0xFFFFF1B8),
    Color(0xFFFFD6A5),
    Color(0xFFFFADAD),
    Color(0xFFCAFFBF),
    Color(0xFF9BF6FF),
    Color(0xFFA0C4FF),
    Color(0xFFBDB2FF),
    Color(0xFFFFC6FF),
  ];

  /// Curated gradients.
  static const List<NoteGradient> gradients = [
    NoteGradient(
        'sunset', [Color(0xFFFF9A9E), Color(0xFFFAD0C4)], Brightness.light),
    NoteGradient(
        'peach', [Color(0xFFFFECD2), Color(0xFFFCB69F)], Brightness.light),
    NoteGradient(
        'gold', [Color(0xFFF7971E), Color(0xFFFFD200)], Brightness.light),
    NoteGradient(
        'ocean', [Color(0xFF2193B0), Color(0xFF6DD5ED)], Brightness.dark),
    NoteGradient(
        'grape', [Color(0xFF667EEA), Color(0xFF764BA2)], Brightness.dark),
    NoteGradient(
        'forest', [Color(0xFF11998E), Color(0xFF38EF7D)], Brightness.dark),
    NoteGradient(
        'rose', [Color(0xFFEC008C), Color(0xFFFC6767)], Brightness.dark),
    NoteGradient(
        'night', [Color(0xFF232526), Color(0xFF414345)], Brightness.dark),
  ];

  factory NoteBackground.fromToken(String? token) {
    if (token == null || token.isEmpty) return none;
    if (token.startsWith('c:')) {
      final value = int.tryParse(token.substring(2), radix: 16);
      return value == null ? none : NoteBackground.solid(Color(value));
    }
    if (token.startsWith('g:')) {
      final id = token.substring(2);
      final g = gradients.where((e) => e.id == id);
      return g.isEmpty ? none : NoteBackground.gradient(g.first);
    }
    if (token.startsWith('img:')) {
      return NoteBackground.image(token.substring(4));
    }
    return none;
  }

  String? get token => switch (type) {
        NoteBgType.none => null,
        NoteBgType.solid =>
          'c:${_color!.toARGB32().toRadixString(16).padLeft(8, '0')}',
        NoteBgType.gradient => 'g:${_gradient!.id}',
        NoteBgType.image => 'img:$imageFile',
      };

  bool get isNone => type == NoteBgType.none;
  bool get isImage => type == NoteBgType.image;

  /// True when a dark scrim should sit between the background and the text.
  bool get needsScrim => type == NoteBgType.image;

  /// Brightness of the surface; [fallback] is used for the default background
  /// so it follows the active theme.
  Brightness surfaceBrightness(Brightness fallback) => switch (type) {
        NoteBgType.none => fallback,
        NoteBgType.solid => ThemeData.estimateBrightnessForColor(_color!),
        NoteBgType.gradient => _gradient!.brightness,
        NoteBgType.image => Brightness.dark,
      };

  /// Box decoration for this background (without the scrim).
  BoxDecoration decoration(ColorScheme scheme, {double radius = 20}) {
    final r = BorderRadius.circular(radius);
    return switch (type) {
      NoteBgType.none =>
        BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: r),
      NoteBgType.solid => BoxDecoration(color: _color, borderRadius: r),
      NoteBgType.gradient =>
        BoxDecoration(gradient: _gradient!.gradient, borderRadius: r),
      NoteBgType.image => BoxDecoration(
          borderRadius: r,
          image: DecorationImage(
            image: FileImage(File(AppPaths.backgroundFile(imageFile!))),
            fit: BoxFit.cover,
          ),
        ),
    };
  }

  // --- Adaptive text colours ------------------------------------------------

  Color primaryText(ColorScheme scheme, Brightness themeBrightness) {
    if (isNone) return scheme.onSurface;
    return surfaceBrightness(themeBrightness) == Brightness.light
        ? Colors.black.withValues(alpha: 0.88)
        : Colors.white;
  }

  Color secondaryText(ColorScheme scheme, Brightness themeBrightness) {
    if (isNone) return scheme.onSurfaceVariant;
    return surfaceBrightness(themeBrightness) == Brightness.light
        ? Colors.black.withValues(alpha: 0.66)
        : Colors.white.withValues(alpha: 0.82);
  }

  Color tertiaryText(ColorScheme scheme, Brightness themeBrightness) {
    if (isNone) return scheme.outline;
    return surfaceBrightness(themeBrightness) == Brightness.light
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.white.withValues(alpha: 0.7);
  }
}
