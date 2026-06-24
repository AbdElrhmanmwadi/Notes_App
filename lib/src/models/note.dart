import 'package:intl/intl.dart';

/// Immutable domain model for a note.
class Note {
  const Note({
    this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
    this.color,
    this.isPinned = false,
  });

  final int? id;
  final String title;
  final String body;

  /// Raw value stored in the `date` column. New rows store an ISO-8601 string;
  /// legacy rows may contain a pre-formatted string (kept for display only).
  final String updatedAt;

  /// ARGB colour for the card background, or null for the default surface.
  final int? color;

  final bool isPinned;

  factory Note.fromMap(Map<String, Object?> map) => Note(
        id: map['id'] as int?,
        title: (map['title'] as String?) ?? '',
        body: (map['note'] as String?) ?? '',
        updatedAt: (map['date'] as String?) ?? '',
        color: map['color'] as int?,
        isPinned: (map['isPinned'] as int? ?? 0) == 1,
      );

  /// Column map for persistence. `id` is omitted so SQLite can auto-increment;
  /// pass [withId] = true to preserve the id (used to restore after an undo).
  Map<String, Object?> toMap({bool withId = false}) => {
        if (withId && id != null) 'id': id,
        'title': title,
        'note': body,
        'date': updatedAt,
        'color': color,
        'isPinned': isPinned ? 1 : 0,
      };

  /// Human-readable date. Falls back to the raw string for legacy rows whose
  /// `date` was stored in a non-parseable format.
  String get displayDate {
    final parsed = DateTime.tryParse(updatedAt);
    if (parsed == null) return updatedAt;
    return DateFormat('MMM d, h:mm a').format(parsed);
  }

  bool get isEmpty => title.trim().isEmpty && body.trim().isEmpty;

  Note copyWith({
    int? id,
    String? title,
    String? body,
    String? updatedAt,
    int? color,
    bool? isPinned,
    bool clearColor = false,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        updatedAt: updatedAt ?? this.updatedAt,
        color: clearColor ? null : (color ?? this.color),
        isPinned: isPinned ?? this.isPinned,
      );
}
