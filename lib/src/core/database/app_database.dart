import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../models/note_query.dart';

/// Thin, safe wrapper around the application's SQLite database.
///
/// All write/read helpers use parameterised queries (`whereArgs`) to avoid
/// SQL injection. The connection is opened lazily and cached for the lifetime
/// of the app.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'note.db';
  static const _dbVersion = 9;

  /// Notes in the trash older than this are purged automatically.
  static const trashRetention = Duration(days: 30);

  static const notesTable = 'notes';
  static const tasksTable = 'tasks';
  static const settingsTable = 'settings';
  static const _notesFts = 'notes_fts';

  /// Test hook: when true the database opens in memory, giving each test a
  /// clean, isolated instance.
  @visibleForTesting
  static bool useInMemory = false;

  Database? _db;

  /// Whether the FTS5 virtual table is available. Falls back to `LIKE` search
  /// when the platform's SQLite was built without FTS5.
  bool _ftsEnabled = false;

  Future<Database> get _database async => _db ??= await _open();

  Future<Database> _open() async {
    final path = useInMemory
        ? inMemoryDatabasePath
        : p.join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await _ensureSettings(db);
        _ftsEnabled = await _ensureFts(db);
      },
    );
  }

  /// Simple key/value store for app preferences (e.g. theme mode). Created via
  /// onOpen so it exists on both fresh and upgraded databases without a version
  /// bump.
  Future<void> _ensureSettings(Database db) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS $settingsTable '
      '(key TEXT PRIMARY KEY, value TEXT)',
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await _database;
    final rows = await db.query(settingsTable,
        columns: ['value'], where: 'key = ?', whereArgs: [key], limit: 1);
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    await insert(settingsTable, {'key': key, 'value': value});
  }

  /// Closes and forgets the connection. Used between tests.
  @visibleForTesting
  Future<void> close() async {
    await _db?.close();
    _db = null;
    _ftsEnabled = false;
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    batch.execute('''
      CREATE TABLE $notesTable (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        title      TEXT    NOT NULL DEFAULT '',
        note       TEXT    NOT NULL DEFAULT '',
        date       TEXT,
        color      INTEGER,
        background TEXT,
        tags       TEXT,
        isPinned   INTEGER NOT NULL DEFAULT 0,
        isArchived INTEGER NOT NULL DEFAULT 0,
        deletedAt  INTEGER
      )
    ''');
    batch.execute('''
      CREATE TABLE $tasksTable (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        task       TEXT    NOT NULL,
        date       TEXT,
        isComplete INTEGER NOT NULL DEFAULT 0,
        reminderAt INTEGER,
        priority   INTEGER NOT NULL DEFAULT 0,
        recurrence INTEGER NOT NULL DEFAULT 0,
        subtasks   TEXT
      )
    ''');
    await batch.commit();
  }

  /// Idempotent, additive migrations. Each [ALTER] is guarded by a column
  /// check so the migration is safe regardless of which historical version a
  /// device is upgrading from (including the broken v4 that shipped without the
  /// `isComplete` column).
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final addedIsComplete = await _ensureColumn(db, tasksTable, 'isComplete',
        'ALTER TABLE $tasksTable ADD COLUMN isComplete INTEGER NOT NULL DEFAULT 0');

    // Older builds used an inverted flag (1 = active, 0 = done). If the column
    // already held data under that convention, normalise it to the new one
    // (1 = done, 0 = active) exactly once, here during the upgrade.
    if (!addedIsComplete) {
      await db.execute(
        'UPDATE $tasksTable SET isComplete = 1 - isComplete '
        'WHERE isComplete IN (0, 1)',
      );
    }

    await _ensureColumn(
        db, tasksTable, 'date', 'ALTER TABLE $tasksTable ADD COLUMN date TEXT');
    await _ensureColumn(db, tasksTable, 'reminderAt',
        'ALTER TABLE $tasksTable ADD COLUMN reminderAt INTEGER');
    await _ensureColumn(
        db, notesTable, 'date', 'ALTER TABLE $notesTable ADD COLUMN date TEXT');
    await _ensureColumn(db, notesTable, 'color',
        'ALTER TABLE $notesTable ADD COLUMN color INTEGER');
    await _ensureColumn(db, notesTable, 'background',
        'ALTER TABLE $notesTable ADD COLUMN background TEXT');
    await _ensureColumn(db, notesTable, 'isPinned',
        'ALTER TABLE $notesTable ADD COLUMN isPinned INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn(db, notesTable, 'tags',
        'ALTER TABLE $notesTable ADD COLUMN tags TEXT');
    await _ensureColumn(db, tasksTable, 'priority',
        'ALTER TABLE $tasksTable ADD COLUMN priority INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn(db, tasksTable, 'recurrence',
        'ALTER TABLE $tasksTable ADD COLUMN recurrence INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn(db, tasksTable, 'subtasks',
        'ALTER TABLE $tasksTable ADD COLUMN subtasks TEXT');
    await _ensureColumn(db, notesTable, 'isArchived',
        'ALTER TABLE $notesTable ADD COLUMN isArchived INTEGER NOT NULL DEFAULT 0');
    await _ensureColumn(db, notesTable, 'deletedAt',
        'ALTER TABLE $notesTable ADD COLUMN deletedAt INTEGER');
  }

  /// Adds [column] via [alterStatement] when it is missing.
  /// Returns `true` if the column was added, `false` if it already existed.
  Future<bool> _ensureColumn(
    Database db,
    String table,
    String column,
    String alterStatement,
  ) async {
    final info = await db.rawQuery('PRAGMA table_info($table)');
    final exists = info.any((row) => row['name'] == column);
    if (!exists) await db.execute(alterStatement);
    return !exists;
  }

  /// Creates (if needed) the FTS5 index mirroring [notesTable] and keeps it in
  /// sync via triggers. Returns whether FTS5 is usable on this platform.
  Future<bool> _ensureFts(Database db) async {
    try {
      await db.execute(
        "CREATE VIRTUAL TABLE IF NOT EXISTS $_notesFts "
        "USING fts5(title, note, content='$notesTable', content_rowid='id')",
      );
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS notes_ai AFTER INSERT ON $notesTable BEGIN
          INSERT INTO $_notesFts(rowid, title, note)
          VALUES (new.id, new.title, new.note);
        END
      ''');
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS notes_ad AFTER DELETE ON $notesTable BEGIN
          INSERT INTO $_notesFts($_notesFts, rowid, title, note)
          VALUES ('delete', old.id, old.title, old.note);
        END
      ''');
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS notes_au AFTER UPDATE ON $notesTable BEGIN
          INSERT INTO $_notesFts($_notesFts, rowid, title, note)
          VALUES ('delete', old.id, old.title, old.note);
          INSERT INTO $_notesFts(rowid, title, note)
          VALUES (new.id, new.title, new.note);
        END
      ''');

      // Back-fill the index the first time it is created on an existing DB.
      final indexed = Sqflite.firstIntValue(
              await db.rawQuery('SELECT count(*) FROM $_notesFts')) ??
          0;
      final total = Sqflite.firstIntValue(
              await db.rawQuery('SELECT count(*) FROM $notesTable')) ??
          0;
      if (indexed == 0 && total > 0) {
        await db.execute(
          'INSERT INTO $_notesFts(rowid, title, note) '
          'SELECT id, title, note FROM $notesTable',
        );
      }
      return true;
    } catch (_) {
      // SQLite built without FTS5 — search will use a LIKE fallback.
      return false;
    }
  }

  // --- Notes search ---------------------------------------------------------

  /// Full-text search over notes within a [scope] (active list / archive /
  /// trash), ordered by [sort]. Uses FTS5 when available and transparently
  /// falls back to `LIKE`. Expired trash is purged first.
  ///
  /// The scope/sort clauses are built from fixed enum values (never user
  /// input), so the string interpolation here carries no injection risk; the
  /// query text itself stays parameterised.
  Future<List<Map<String, Object?>>> searchNotes(
    String rawQuery, {
    NoteScope scope = NoteScope.active,
    NoteSort sort = NoteSort.updated,
  }) async {
    final db = await _database;
    await _purgeExpiredTrash(db);
    final trimmed = rawQuery.trim();
    final orderBy = _orderClause(scope, sort, '');

    if (trimmed.isEmpty) {
      return db.query(notesTable,
          where: _scopeClause(scope, ''), orderBy: orderBy);
    }

    if (_ftsEnabled) {
      try {
        // Turn the user input into a safe prefix query: term1* term2*
        final match = trimmed
            .split(RegExp(r'\s+'))
            .map((t) => '"${t.replaceAll('"', '')}"*')
            .join(' ');
        return await db.rawQuery(
          'SELECT n.* FROM $notesTable n '
          'JOIN $_notesFts f ON n.id = f.rowid '
          'WHERE $_notesFts MATCH ? AND ${_scopeClause(scope, 'n.')} '
          'ORDER BY ${_orderClause(scope, sort, 'n.')}',
          [match],
        );
      } catch (_) {
        // Fall through to LIKE on any malformed-query error.
      }
    }

    final like = '%$trimmed%';
    return db.query(
      notesTable,
      where: '(title LIKE ? OR note LIKE ?) AND ${_scopeClause(scope, '')}',
      whereArgs: [like, like],
      orderBy: orderBy,
    );
  }

  /// SQL predicate restricting rows to [scope]. [alias] is a table prefix such
  /// as `n.` (or empty for an un-aliased query).
  String _scopeClause(NoteScope scope, String alias) => switch (scope) {
        NoteScope.active => '${alias}deletedAt IS NULL AND ${alias}isArchived = 0',
        NoteScope.archived =>
          '${alias}deletedAt IS NULL AND ${alias}isArchived = 1',
        NoteScope.trash => '${alias}deletedAt IS NOT NULL',
      };

  /// `ORDER BY` clause for [scope]/[sort]. Trash is always newest-deleted first;
  /// other scopes keep pinned notes on top, then apply the chosen order.
  String _orderClause(NoteScope scope, NoteSort sort, String alias) {
    if (scope == NoteScope.trash) return '${alias}deletedAt DESC';
    final pin = '${alias}isPinned DESC, ';
    return switch (sort) {
      NoteSort.updated => '$pin${alias}date DESC, ${alias}id DESC',
      NoteSort.title => '$pin${alias}title COLLATE NOCASE ASC, ${alias}id DESC',
      NoteSort.created => '$pin${alias}id DESC',
    };
  }

  /// Permanently removes trashed notes older than [trashRetention].
  Future<void> _purgeExpiredTrash(Database db) async {
    final cutoff =
        DateTime.now().subtract(trashRetention).millisecondsSinceEpoch;
    await db.delete(notesTable,
        where: 'deletedAt IS NOT NULL AND deletedAt < ?', whereArgs: [cutoff]);
  }

  // --- Generic CRUD ---------------------------------------------------------

  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final db = await _database;
    return db.query(table,
        where: where, whereArgs: whereArgs, orderBy: orderBy);
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    final db = await _database;
    return db.insert(table, values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await _database;
    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await _database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }
}
