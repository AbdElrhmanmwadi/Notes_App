import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/notes_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/tasks_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

/// Registers the long-lived controllers exactly once, before the first screen
/// is built.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController(), permanent: true);
    Get.put(NotesController(), permanent: true);
    Get.put(TasksController(), permanent: true);
  }
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialBinding: AppBinding(),
      home: const HomeScreen(),
    );
  }
}
