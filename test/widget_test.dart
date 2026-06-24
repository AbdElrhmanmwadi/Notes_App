// Unit tests for the model mapping layer. These cover the data conversions
// that the old code got wrong (notably the inverted task-completion flag and
// the column<->field naming), without requiring the sqflite plugin.

import 'package:flutter_test/flutter_test.dart';
import 'package:note/src/models/note.dart';
import 'package:note/src/models/task.dart';

void main() {
  group('Note', () {
    test('round-trips through a column map', () {
      const note = Note(
          title: 'Groceries',
          body: 'Milk',
          updatedAt: '2024-01-01T10:00:00.000');
      final map = note.toMap();

      expect(map['title'], 'Groceries');
      expect(map['note'], 'Milk'); // body is stored in the `note` column.

      final restored = Note.fromMap({...map, 'id': 1});
      expect(restored.id, 1);
      expect(restored.title, 'Groceries');
      expect(restored.body, 'Milk');
    });

    test('isEmpty ignores whitespace', () {
      expect(
          const Note(title: '  ', body: '\n', updatedAt: '').isEmpty, isTrue);
      expect(const Note(title: 'x', body: '', updatedAt: '').isEmpty, isFalse);
    });

    test('displayDate falls back to the raw value for legacy rows', () {
      expect(
          const Note(title: '', body: '', updatedAt: 'Mon, Jun 24').displayDate,
          'Mon, Jun 24');
    });
  });

  group('Task', () {
    test('maps isComplete to/from the 0/1 column correctly', () {
      expect(Task.fromMap({'task': 'a', 'isComplete': 1}).isComplete, isTrue);
      expect(Task.fromMap({'task': 'a', 'isComplete': 0}).isComplete, isFalse);

      const done = Task(title: 'a', isComplete: true, updatedAt: '');
      expect(done.toMap()['isComplete'], 1);
    });
  });
}
