import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/core/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  // Fire-and-forget: don't block first paint on the permission dialog.
  NotificationService.instance.requestPermissions();
  runApp(const NoteApp());
}
