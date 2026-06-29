import 'package:get/get.dart';

import '../core/database/app_database.dart';
import '../core/notifications/notification_service.dart';
import '../models/subtask.dart';
import '../models/task.dart';
import '../models/task_priority.dart';
import '../models/task_recurrence.dart';

/// Reactive store for tasks, split into active and completed buckets, with
/// optional reminder scheduling.
class TasksController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;
  final NotificationService _notifications = NotificationService.instance;

  final RxList<Task> _tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;

  /// Whether the collapsible "Completed" section is expanded.
  final RxBool showCompleted = true.obs;

  /// Active tasks, highest priority first; ties keep newest-first order.
  List<Task> get activeTasks {
    final active = _tasks.where((t) => !t.isComplete).toList();
    active.sort((a, b) {
      final byPriority = b.priority.index.compareTo(a.priority.index);
      if (byPriority != 0) return byPriority;
      return (b.id ?? 0).compareTo(a.id ?? 0); // newest first within a tier
    });
    return active;
  }

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

  Future<void> add(String title,
      {DateTime? reminderAt,
      TaskPriority priority = TaskPriority.none,
      Recurrence recurrence = Recurrence.none,
      List<Subtask> subtasks = const []}) async {
    if (title.trim().isEmpty) return;
    final id = await _db.insert(
      AppDatabase.tasksTable,
      Task(
        title: title.trim(),
        isComplete: false,
        updatedAt: DateTime.now().toIso8601String(),
        reminderAt: reminderAt,
        priority: priority,
        recurrence: recurrence,
        subtasks: subtasks,
      ).toMap(),
    );
    if (reminderAt != null) {
      await _notifications.schedule(
          id: id,
          title: title.trim(),
          when: reminderAt,
          recurrence: recurrence);
    }
    await load();
  }

  Future<void> edit(Task task,
      {String? title,
      DateTime? reminderAt,
      TaskPriority? priority,
      Recurrence? recurrence,
      List<Subtask>? subtasks,
      bool clearReminder = false}) async {
    if (task.id == null) return;
    final newTitle = (title ?? task.title).trim();
    if (newTitle.isEmpty) return;
    final newReminder = clearReminder ? null : (reminderAt ?? task.reminderAt);
    final newPriority = priority ?? task.priority;
    final newRecurrence = recurrence ?? task.recurrence;
    final newSubtasks = subtasks ?? task.subtasks;

    await _db.update(
      AppDatabase.tasksTable,
      {
        'task': newTitle,
        'reminderAt': newReminder?.millisecondsSinceEpoch,
        'priority': newPriority.index,
        'recurrence': newRecurrence.index,
        'subtasks': Subtask.encode(newSubtasks),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );

    await _notifications.cancel(task.id!);
    if (newReminder != null && !task.isComplete) {
      await _notifications.schedule(
          id: task.id!,
          title: newTitle,
          when: newReminder,
          recurrence: newRecurrence);
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
    // A completed task shouldn't still fire its reminder (recurring included).
    if (nowComplete) await _notifications.cancel(task.id!);
    if (!nowComplete && task.reminderAt != null) {
      await _notifications.schedule(
          id: task.id!,
          title: task.title,
          when: task.reminderAt!,
          recurrence: task.recurrence);
    }
    await load();
  }

  /// Toggles a single subtask (by index) and persists the change. Used for
  /// ticking checklist items inline without opening the editor.
  Future<void> toggleSubtask(Task task, int index) async {
    if (task.id == null || index < 0 || index >= task.subtasks.length) return;
    final updated = [...task.subtasks];
    updated[index] =
        updated[index].copyWith(isComplete: !updated[index].isComplete);
    await _db.update(
      AppDatabase.tasksTable,
      {'subtasks': Subtask.encode(updated)},
      where: 'id = ?',
      whereArgs: [task.id],
    );
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
          id: task.id!,
          title: task.title,
          when: task.reminderAt!,
          recurrence: task.recurrence);
    }
    await load();
  }
}
