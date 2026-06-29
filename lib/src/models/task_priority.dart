import 'package:flutter/material.dart';

/// Importance level for a task. Stored as the [index] in the `priority` column
/// (`0` = none) so it round-trips through SQLite as a plain integer.
enum TaskPriority {
  none,
  low,
  medium,
  high;

  /// Maps a stored integer back to a priority, defaulting to [none] for null or
  /// out-of-range values from older rows.
  static TaskPriority fromValue(int? value) {
    if (value == null || value < 0 || value >= TaskPriority.values.length) {
      return TaskPriority.none;
    }
    return TaskPriority.values[value];
  }

  bool get isSet => this != TaskPriority.none;

  String get label => switch (this) {
        TaskPriority.none => 'None',
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
      };

  /// Accent colour for flags/badges. [none] has no colour.
  Color? get color => switch (this) {
        TaskPriority.none => null,
        TaskPriority.low => const Color(0xFF4CAF50),
        TaskPriority.medium => const Color(0xFFFF9800),
        TaskPriority.high => const Color(0xFFE53935),
      };
}
