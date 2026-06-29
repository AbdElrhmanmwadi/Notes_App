import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/database/app_database.dart';
import '../core/theme/app_theme.dart';

/// Persists and applies the user's appearance preferences ([ThemeMode] and
/// accent colour). Stored in the `settings` table so choices survive restarts.
///
/// Both values are reactive and read directly by [GetMaterialApp], so changing
/// them re-themes the whole app instantly.
class SettingsController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;

  static const _themeKey = 'theme_mode';
  static const _accentKey = 'accent_color';

  /// Selectable accent presets shown in Settings (the first is the brand seed).
  static const List<Color> accentPresets = [
    AppTheme.defaultSeed, // amber
    Color(0xFFEF5350), // red
    Color(0xFFEC407A), // pink
    Color(0xFFAB47BC), // purple
    Color(0xFF5C6BC0), // indigo
    Color(0xFF42A5F5), // blue
    Color(0xFF26A69A), // teal
    Color(0xFF66BB6A), // green
  ];

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Color> accentColor = AppTheme.defaultSeed.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    themeMode.value = _parse(await _db.getSetting(_themeKey));
    final storedAccent = int.tryParse(await _db.getSetting(_accentKey) ?? '');
    if (storedAccent != null) accentColor.value = Color(storedAccent);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _db.setSetting(_themeKey, mode.name);
  }

  Future<void> setAccentColor(Color color) async {
    accentColor.value = color;
    await _db.setSetting(_accentKey, color.toARGB32().toString());
  }

  ThemeMode _parse(String? value) {
    return ThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
