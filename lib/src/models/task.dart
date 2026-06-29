import 'task_priority.dart';

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
  });

  final int? id;
  final String title;
  final bool isComplete;
  final String updatedAt;

  /// Optional reminder time. Stored as milliseconds since epoch.
  final DateTime? reminderAt;

  /// Importance level. Persisted as its [TaskPriority.index] in the DB.
  final TaskPriority priority;

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
      };

  /// A stable notification id derived from the row id.
  int? get notificationId => id;

  bool get hasActiveReminder =>
      reminderAt != null && !isComplete && reminderAt!.isAfter(DateTime.now());

  Task copyWith({
    int? id,
    String? title,
    bool? isComplete,
    String? updatedAt,
    DateTime? reminderAt,
    TaskPriority? priority,
    bool clearReminder = false,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        isComplete: isComplete ?? this.isComplete,
        updatedAt: updatedAt ?? this.updatedAt,
        reminderAt: clearReminder ? null : (reminderAt ?? this.reminderAt),
        priority: priority ?? this.priority,
      );
}
