import 'package:get/get.dart';

import '../core/database/app_database.dart';
import '../core/notifications/notification_service.dart';
import '../models/task.dart';

/// Reactive store for tasks, split into active and completed buckets, with
/// optional reminder scheduling.
class TasksController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;
  final NotificationService _notifications = NotificationService.instance;

  final RxList<Task> _tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;

  /// Whether the collapsible "Completed" section is expanded.
  final RxBool showCompleted = true.obs;

  List<Task> get activeTasks =>
      _tasks.where((t) => !t.isComplete).toList(growable: false);

  List<Task> get completedTasks =>
      _tasks.where((t) => t.isComplete).toList(growable: false);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    final rows = await _db.query(AppDatabase.tasksTable, orderBy: 'id DESC');
    _tasks.assignAll(rows.map(Task.fromMap));
    isLoading.value = false;
  }

  Future<void> add(String title, {DateTime? reminderAt}) async {
    if (title.trim().isEmpty) return;
    final id = await _db.insert(
      AppDatabase.tasksTable,
      Task(
        title: title.trim(),
        isComplete: false,
        updatedAt: DateTime.now().toIso8601String(),
        reminderAt: reminderAt,
      ).toMap(),
    );
    if (reminderAt != null) {
      await _notifications.schedule(
          id: id, title: title.trim(), when: reminderAt);
    }
    await load();
  }

  Future<void> edit(Task task,
      {String? title, DateTime? reminderAt, bool clearReminder = false}) async {
    if (task.id == null) return;
    final newTitle = (title ?? task.title).trim();
    if (newTitle.isEmpty) return;
    final newReminder = clearReminder ? null : (reminderAt ?? task.reminderAt);

    await _db.update(
      AppDatabase.tasksTable,
      {
        'task': newTitle,
        'reminderAt': newReminder?.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );

    await _notifications.cancel(task.id!);
    if (newReminder != null) {
      await _notifications.schedule(
          id: task.id!, title: newTitle, when: newReminder);
    }
    await load();
  }

  Future<void> toggleComplete(Task task) async {
    if (task.id == null) return;
    final nowComplete = !task.isComplete;
    await _db.update(
      AppDatabase.tasksTable,
      {'isComplete': nowComplete ? 1 : 0},
      where: 'id = ?',
      whereArgs: [task.id],
    );
    // A completed task shouldn't still fire its reminder.
    if (nowComplete) await _notifications.cancel(task.id!);
    if (!nowComplete && task.reminderAt != null) {
      await _notifications.schedule(
          id: task.id!, title: task.title, when: task.reminderAt!);
    }
    await load();
  }

  Future<void> delete(int id) async {
    await _db.delete(AppDatabase.tasksTable, where: 'id = ?', whereArgs: [id]);
    await _notifications.cancel(id);
    await load();
  }

  /// Re-inserts a previously deleted task (preserving its id) for undo, and
  /// re-schedules its reminder if still in the future.
  Future<void> restore(Task task) async {
    await _db.insert(AppDatabase.tasksTable, task.toMap(withId: true));
    if (task.hasActiveReminder) {
      await _notifications.schedule(
          id: task.id!, title: task.title, when: task.reminderAt!);
    }
    await load();
  }
}
