/// How often a task's reminder repeats. Stored as the [index] in the
/// `recurrence` column (`0` = none).
///
/// The semantics are "remind me until it's done": a recurring reminder re-fires
/// on its schedule while the task is active, and stops when the task is
/// completed or deleted.
enum Recurrence {
  none,
  daily,
  weekly;

  static Recurrence fromValue(int? value) {
    if (value == null || value < 0 || value >= Recurrence.values.length) {
      return Recurrence.none;
    }
    return Recurrence.values[value];
  }

  bool get isSet => this != Recurrence.none;

  String get label => switch (this) {
        Recurrence.none => 'Once',
        Recurrence.daily => 'Daily',
        Recurrence.weekly => 'Weekly',
      };
}
