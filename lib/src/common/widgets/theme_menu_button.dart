import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings_controller.dart';

/// AppBar action that lets the user switch between System / Light / Dark.
class ThemeMenuButton extends StatelessWidget {
  const ThemeMenuButton({super.key});

  IconData _iconFor(ThemeMode mode) => switch (mode) {
        ThemeMode.light => Icons.light_mode_outlined,
        ThemeMode.dark => Icons.dark_mode_outlined,
        ThemeMode.system => Icons.brightness_auto_outlined,
      };

  String _labelFor(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'System',
      };

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    return Obx(
      () => PopupMenuButton<ThemeMode>(
        icon: Icon(_iconFor(settings.themeMode.value)),
        tooltip: 'Theme',
        onSelected: settings.setThemeMode,
        itemBuilder: (context) => [
          for (final mode in ThemeMode.values)
            CheckedPopupMenuItem(
              value: mode,
              checked: settings.themeMode.value == mode,
              child: Row(
                children: [
                  Icon(_iconFor(mode), size: 20),
                  const SizedBox(width: 12),
                  Text(_labelFor(mode)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
