// Integration tests for the database layer, run against an in-memory SQLite
// via sqflite_common_ffi (no device/emulator needed).

import 'package:flutter_test/flutter_test.dart';
import 'package:note/src/core/database/app_database.dart';
import 'package:note/src/models/note.dart';
import 'package:note/src/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  final db = AppDatabase.instance;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    AppDatabase.useInMemory = true;
  });

  setUp(() async {
    await db.close(); // fresh in-memory database per test
  });

  Future<int> insertNote(String title, String body, {bool pinned = false}) {
    return db.insert(
      AppDatabase.notesTable,
      Note(
              title: title,
              body: body,
              updatedAt: '2024-01-01T00:00:00.000',
              isPinned: pinned)
          .toMap(),
    );
  }

  group('notes', () {
    test('insert then search finds the note', () async {
      await insertNote('Shopping', 'milk and eggs');
      await insertNote('Workout', 'leg day');

      final hits = await db.searchNotes('milk');
      expect(hits, hasLength(1));
      expect(Note.fromMap(hits.first).title, 'Shopping');
    });

    test('empty query returns all notes, pinned first', () async {
      await insertNote('Plain', 'a');
      await insertNote('Important', 'b', pinned: true);

      final all = await db.searchNotes('');
      expect(all, hasLength(2));
      expect(Note.fromMap(all.first).isPinned, isTrue);
    });

    test('delete removes the note', () async {
      final id = await insertNote('Temp', 'x');
      await db.delete(AppDatabase.notesTable, where: 'id = ?', whereArgs: [id]);
      expect(await db.searchNotes(''), isEmpty);
    });
  });

  group('tasks', () {
    test('round-trips completion and reminder', () async {
      final reminder = DateTime(2030, 1, 1, 9, 0);
      final id = await db.insert(
        AppDatabase.tasksTable,
        Task(
                title: 'Call',
                isComplete: false,
                updatedAt: '',
                reminderAt: reminder)
            .toMap(),
      );

      await db.update(AppDatabase.tasksTable, {'isComplete': 1},
          where: 'id = ?', whereArgs: [id]);

      final rows = await db.query(AppDatabase.tasksTable);
      final task = Task.fromMap(rows.single);
      expect(task.isComplete, isTrue);
      expect(task.reminderAt, reminder);
    });
  });
}
