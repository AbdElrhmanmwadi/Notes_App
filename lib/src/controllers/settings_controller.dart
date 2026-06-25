import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/database/app_database.dart';

/// Persists and applies the user's preferred [ThemeMode]. Stored in the
/// `settings` table so the choice survives restarts.
class SettingsController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;

  static const _themeKey = 'theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final stored = await _db.getSetting(_themeKey);
    final mode = _parse(stored);
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _db.setSetting(_themeKey, mode.name);
  }

  ThemeMode _parse(String? value) {
    return ThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
