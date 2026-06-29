import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Resolves and caches app directories once at startup so the rest of the app
/// can reference saved background images synchronously (e.g. inside `build`).
class AppPaths {
  AppPaths._();

  static String _backgroundsDir = '';

  /// Absolute directory where note background images are stored.
  static String get backgroundsDir => _backgroundsDir;

  static Future<void> init() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'note_backgrounds'));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    _backgroundsDir = dir.path;
  }

  /// Absolute path for a background image [fileName].
  static String backgroundFile(String fileName) =>
      p.join(_backgroundsDir, fileName);
}
