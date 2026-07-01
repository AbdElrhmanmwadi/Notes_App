import 'package:get/get.dart';

import '../core/database/app_database.dart';
import '../models/note.dart';
import '../models/note_query.dart';

/// Reactive store for notes. Search runs in the database layer (FTS5 with a
/// LIKE fallback) and is debounced, so the UI never queries inside `build`.
class NotesController extends GetxController {
  final AppDatabase _db = AppDatabase.instance;

  /// Notes after the active [tagFilter] has been applied — what the UI shows.
  final RxList<Note> notes = <Note>[].obs;
  final RxString query = ''.obs;
  final RxBool isLoading = true.obs;

  /// Which shelf the list is showing: the main notes, the archive, or the
  /// trash. Changing it reloads the list.
  final Rx<NoteScope> scope = NoteScope.active.obs;

  /// Ordering for the active/archive scopes (trash is always newest-deleted
  /// first, regardless of this value).
  final Rx<NoteSort> sort = NoteSort.updated.obs;

  /// Active tag filter, or null for "all". Applied in memory on top of search.
  final Rxn<String> tagFilter = Rxn<String>();

  /// Every distinct tag across all notes (case-insensitive), sorted. Drives the
  /// filter chips. Recomputed from the unfiltered result set on each refresh.
  final RxList<String> allTags = <String>[].obs;

  List<Note> _allNotes = const [];

  @override
  void onInit() {
    super.onInit();
    // Debounce keystrokes so we don't hit the DB on every character.
    debounce(query, (_) => _refresh(), time: const Duration(milliseconds: 250));
    ever(tagFilter, (_) => _applyFilter());
    // Switching shelf or order reloads immediately (no debounce needed).
    ever(scope, (_) => _refresh());
    ever(sort, (_) => _refresh());
    _refresh();
  }

  Future<void> _refresh() async {
    isLoading.value = true;
    final rows = await _db.searchNotes(
      query.value,
      scope: scope.value,
      sort: sort.value,
    );
    _allNotes = rows.map(Note.fromMap).toList(growable: false);
    _recomputeTags();
    _applyFilter();
    isLoading.value = false;
  }

  void _recomputeTags() {
    final seen = <String, String>{}; // lowercase key -> first-seen display form
    for (final note in _allNotes) {
      for (final tag in note.tags) {
        seen.putIfAbsent(tag.toLowerCase(), () => tag);
      }
    }
    final tags = seen.values.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    allTags.assignAll(tags);
    // Drop a filter that no longer matches any note (e.g. last tag removed).
    if (tagFilter.value != null &&
        !seen.containsKey(tagFilter.value!.toLowerCase())) {
      tagFilter.value = null;
    }
  }

  void _applyFilter() {
    final filter = tagFilter.value?.toLowerCase();
    if (filter == null) {
      notes.assignAll(_allNotes);
    } else {
      notes.assignAll(_allNotes.where(
          (n) => n.tags.any((t) => t.toLowerCase() == filter)));
    }
  }

  /// Inserts a new note or updates an existing one. Empty notes are ignored.
  Future<void> save(Note note) async {
    if (note.isEmpty) return;
    final stamped = note.copyWith(updatedAt: DateTime.now().toIso8601String());
    if (stamped.id == null) {
      await _db.insert(AppDatabase.notesTable, stamped.toMap());
    } else {
      await _db.update(
        AppDatabase.notesTable,
        stamped.toMap(),
        where: 'id = ?',
        whereArgs: [stamped.id],
      );
    }
    await _refresh();
  }

  Future<void> togglePin(Note note) async {
    if (note.id == null) return;
    await _db.update(
      AppDatabase.notesTable,
      {'isPinned': note.isPinned ? 0 : 1},
      where: 'id = ?',
      whereArgs: [note.id],
    );
    await _refresh();
  }

  /// Moves a note to (or out of) the archive. Archived notes are hidden from
  /// the main list but keep their content and tags.
  Future<void> setArchived(Note note, bool archived) async {
    await _setColumns(note.id, {'isArchived': archived ? 1 : 0});
  }

  /// Soft-deletes a note by moving it to the trash, where it is recoverable
  /// until [AppDatabase.trashRetention] elapses.
  Future<void> moveToTrash(Note note) async {
    await _setColumns(
        note.id, {'deletedAt': DateTime.now().millisecondsSinceEpoch});
  }

  /// Recovers a trashed note, returning it to whichever shelf it came from
  /// (its archived flag is left untouched).
  Future<void> restoreFromTrash(Note note) async {
    await _setColumns(note.id, {'deletedAt': null});
  }

  /// Permanently removes a single note. Used from the trash — this cannot be
  /// undone.
  Future<void> deleteForever(int id) async {
    await _db.delete(AppDatabase.notesTable, where: 'id = ?', whereArgs: [id]);
    await _refresh();
  }

  /// Permanently empties the trash.
  Future<void> emptyTrash() async {
    await _db.delete(AppDatabase.notesTable,
        where: 'deletedAt IS NOT NULL', whereArgs: const []);
    await _refresh();
  }

  /// Writes [values] onto the note with [id] and reloads. No-ops for a note
  /// that was never persisted.
  Future<void> _setColumns(int? id, Map<String, Object?> values) async {
    if (id == null) return;
    await _db.update(
      AppDatabase.notesTable,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
    await _refresh();
  }
}
