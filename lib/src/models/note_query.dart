/// Which subset of notes to return: the main list, the archive, or the trash.
enum NoteScope {
  active,
  archived,
  trash;

  String get label => switch (this) {
        NoteScope.active => 'Notes',
        NoteScope.archived => 'Archive',
        NoteScope.trash => 'Trash',
      };
}

/// Ordering for a notes query (pinned notes always come first in non-trash
/// scopes; trash is always ordered by deletion time).
enum NoteSort {
  updated,
  title,
  created;

  String get label => switch (this) {
        NoteSort.updated => 'Last updated',
        NoteSort.title => 'Title (A–Z)',
        NoteSort.created => 'Date created',
      };
}
