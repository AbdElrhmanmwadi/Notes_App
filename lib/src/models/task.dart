import 'subtask.dart';
import 'task_priority.dart';
import 'task_recurrence.dart';

/// Immutable domain model for a to-do task.
///
/// `isComplete` is exposed as a real [bool]; the SQLite `0/1` mapping is an
/// implementation detail kept inside [fromMap]/[toMap] (`1` = completed,
/// `0` = active — the inverse of the original, broken convention).
class Task {
  const Task({
    this.id,
    required this.title,
    required this.isComplete,
    required this.updatedAt,
    this.reminderAt,
    this.priority = TaskPriority.none,
    this.recurrence = Recurrence.none,
    this.subtasks = const [],
  });

  final int? id;
  final String title;
  final bool isComplete;
  final String updatedAt;

  /// Optional reminder time. Stored as milliseconds since epoch.
  final DateTime? reminderAt;

  /// Importance level. Persisted as its [TaskPriority.index] in the DB.
  final TaskPriority priority;

  /// How often the reminder repeats. Persisted as [Recurrence.index].
  final Recurrence recurrence;

  /// Checklist items. Persisted as JSON in the `subtasks` column.
  final List<Subtask> subtasks;

  factory Task.fromMap(Map<String, Object?> map) {
    final reminderMillis = map['reminderAt'] as int?;
    return Task(
      id: map['id'] as int?,
      title: (map['task'] as String?) ?? '',
      isComplete: (map['isComplete'] as int? ?? 0) == 1,
      updatedAt: (map['date'] as String?) ?? '',
      reminderAt: reminderMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(reminderMillis),
      priority: TaskPriority.fromValue(map['priority'] as int?),
      recurrence: Recurrence.fromValue(map['recurrence'] as int?),
      subtasks: Subtask.decode(map['subtasks'] as String?),
    );
  }

  /// Pass [withId] = true to preserve the id (used to restore after an undo).
  Map<String, Object?> toMap({bool withId = false}) => {
        if (withId && id != null) 'id': id,
        'task': title,
        'isComplete': isComplete ? 1 : 0,
        'date': updatedAt,
        'reminderAt': reminderAt?.millisecondsSinceEpoch,
        'priority': priority.index,
        'recurrence': recurrence.index,
        'subtasks': Subtask.encode(subtasks),
      };

  /// A stable notification id derived from the row id.
  int? get notificationId => id;

  bool get hasActiveReminder =>
      reminderAt != null &&
      !isComplete &&
      (recurrence.isSet || reminderAt!.isAfter(DateTime.now()));

  bool get hasSubtasks => subtasks.isNotEmpty;

  int get completedSubtasks => subtasks.where((s) => s.isComplete).length;

  Task copyWith({
    int? id,
    String? title,
    bool? isComplete,
    String? updatedAt,
    DateTime? reminderAt,
    TaskPriority? priority,
    Recurrence? recurrence,
    List<Subtask>? subtasks,
    bool clearReminder = false,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        isComplete: isComplete ?? this.isComplete,
        updatedAt: updatedAt ?? this.updatedAt,
        reminderAt: clearReminder ? null : (reminderAt ?? this.reminderAt),
        priority: priority ?? this.priority,
        recurrence: recurrence ?? this.recurrence,
        subtasks: subtasks ?? this.subtasks,
      );
}
