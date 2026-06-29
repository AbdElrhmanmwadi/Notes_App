import 'package:intl/intl.dart';

/// Immutable domain model for a note.
class Note {
  const Note({
    this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
    this.background,
    this.isPinned = false,
  });

  final int? id;
  final String title;
  final String body;

  /// Raw value stored in the `date` column. New rows store an ISO-8601 string;
  /// legacy rows may contain a pre-formatted string (kept for display only).
  final String updatedAt;

  /// Background token: `c:<argb>`, `g:<id>`, `img:<file>`, or null for default.
  /// See [NoteBackground].
  final String? background;

  final bool isPinned;

  factory Note.fromMap(Map<String, Object?> map) => Note(
        id: map['id'] as int?,
        title: (map['title'] as String?) ?? '',
        body: (map['note'] as String?) ?? '',
        updatedAt: (map['date'] as String?) ?? '',
        background: (map['background'] as String?) ??
            _legacyColorToken(map['color'] as int?),
        isPinned: (map['isPinned'] as int? ?? 0) == 1,
      );

  /// Converts a legacy ARGB `color` int into a `c:<argb>` background token.
  static String? _legacyColorToken(int? color) =>
      color == null ? null : 'c:${color.toRadixString(16).padLeft(8, '0')}';

  /// Column map for persistence. `id` is omitted so SQLite can auto-increment;
  /// pass [withId] = true to preserve the id (used to restore after an undo).
  Map<String, Object?> toMap({bool withId = false}) => {
        if (withId && id != null) 'id': id,
        'title': title,
        'note': body,
        'date': updatedAt,
        'background': background,
        'color': null, // legacy column no longer used
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
    String? background,
    bool? isPinned,
    bool clearBackground = false,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        updatedAt: updatedAt ?? this.updatedAt,
        background: clearBackground ? null : (background ?? this.background),
        isPinned: isPinned ?? this.isPinned,
      );
}
