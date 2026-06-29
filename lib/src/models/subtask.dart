import 'dart:convert';

/// A single checklist item belonging to a [Task].
///
/// Subtasks are persisted as a JSON array in the task's `subtasks` text column
/// (the same "encoded column" approach used for tags and note backgrounds),
/// avoiding a separate table and join.
class Subtask {
  const Subtask({required this.title, this.isComplete = false});

  final String title;
  final bool isComplete;

  Subtask copyWith({String? title, bool? isComplete}) => Subtask(
        title: title ?? this.title,
        isComplete: isComplete ?? this.isComplete,
      );

  Map<String, Object?> toJson() => {'t': title, 'd': isComplete};

  factory Subtask.fromJson(Map<String, Object?> json) => Subtask(
        title: (json['t'] as String?)?.trim() ?? '',
        isComplete: (json['d'] as bool?) ?? false,
      );

  /// Decodes the stored JSON column into a list, tolerating null/garbage.
  static List<Subtask> decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    try {
      final data = jsonDecode(raw);
      if (data is! List) return const [];
      return data
          .whereType<Map<String, Object?>>()
          .map(Subtask.fromJson)
          .where((s) => s.title.isNotEmpty)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  /// Encodes a list back to a JSON string, or null when empty (keeps the column
  /// tidy and lets `isEmpty` checks rely on null).
  static String? encode(List<Subtask> items) {
    if (items.isEmpty) return null;
    return jsonEncode(items.map((s) => s.toJson()).toList());
  }
}
