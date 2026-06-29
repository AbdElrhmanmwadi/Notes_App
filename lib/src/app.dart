import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/notes_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/tasks_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

/// Registers the long-lived feature controllers exactly once, before the first
/// screen is built. [SettingsController] is registered earlier (in `main`) so
/// the root widget can read the theme reactively.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotesController(), permanent: true);
    Get.put(TasksController(), permanent: true);
  }
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    // Rebuild the app shell when the theme mode or accent colour changes so the
    // whole UI re-themes instantly.
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes',
        theme: AppTheme.light(seed: settings.accentColor.value),
        darkTheme: AppTheme.dark(seed: settings.accentColor.value),
        themeMode: settings.themeMode.value,
        initialBinding: AppBinding(),
        home: const HomeScreen(),
      ),
    );
  }
}
