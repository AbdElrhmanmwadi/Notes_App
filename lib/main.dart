import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/app.dart';
import 'src/controllers/settings_controller.dart';
import 'src/core/app_paths.dart';
import 'src/core/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPaths.init();
  await NotificationService.instance.init();
  // Fire-and-forget: don't block first paint on the permission dialog.
  NotificationService.instance.requestPermissions();
  // Registered before runApp so the root widget can read the theme reactively
  // (accent colour + theme mode) on its very first build.
  Get.put(SettingsController(), permanent: true);
  runApp(const NoteApp());
}
