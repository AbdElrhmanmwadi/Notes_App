// Unit tests for the model mapping layer. These cover the data conversions
// that the old code got wrong (notably the inverted task-completion flag and
// the column<->field naming), without requiring the sqflite plugin.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note/src/core/theme/note_background.dart';
import 'package:note/src/models/note.dart';
import 'package:note/src/models/subtask.dart';
import 'package:note/src/models/task.dart';
import 'package:note/src/models/task_priority.dart';
import 'package:note/src/models/task_recurrence.dart';

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

    test('tags round-trip through the comma-separated column', () {
      const note = Note(
          title: 't', body: 'b', updatedAt: '', tags: ['work', 'ideas']);
      expect(note.toMap()['tags'], 'work,ideas');
      expect(Note.fromMap(note.toMap()).tags, ['work', 'ideas']);
    });

    test('empty tags persist as null and decode to an empty list', () {
      const note = Note(title: 't', body: 'b', updatedAt: '');
      expect(note.toMap()['tags'], isNull);
      expect(Note.fromMap({'note': 'b', 'tags': null}).tags, isEmpty);
      expect(Note.fromMap({'note': 'b', 'tags': '  '}).tags, isEmpty);
    });

    test('sanitizeTags trims, drops commas, and dedupes case-insensitively', () {
      expect(Note.sanitizeTags([' Work ', 'work', 'a,b', '']),
          ['Work', 'a b']);
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

    test('priority round-trips through the integer column', () {
      const task = Task(
          title: 'a',
          isComplete: false,
          updatedAt: '',
          priority: TaskPriority.high);
      expect(task.toMap()['priority'], TaskPriority.high.index);
      expect(Task.fromMap(task.toMap()).priority, TaskPriority.high);
    });

    test('priority defaults to none for null/out-of-range values', () {
      expect(Task.fromMap({'task': 'a'}).priority, TaskPriority.none);
      expect(Task.fromMap({'task': 'a', 'priority': 99}).priority,
          TaskPriority.none);
    });

    test('recurrence round-trips and defaults to none', () {
      const task = Task(
          title: 'a',
          isComplete: false,
          updatedAt: '',
          recurrence: Recurrence.weekly);
      expect(task.toMap()['recurrence'], Recurrence.weekly.index);
      expect(Task.fromMap(task.toMap()).recurrence, Recurrence.weekly);
      expect(Task.fromMap({'task': 'a'}).recurrence, Recurrence.none);
    });

    test('subtasks round-trip through the JSON column with progress', () {
      const task = Task(
        title: 'a',
        isComplete: false,
        updatedAt: '',
        subtasks: [
          Subtask(title: 'one', isComplete: true),
          Subtask(title: 'two'),
        ],
      );
      final restored = Task.fromMap(task.toMap());
      expect(restored.subtasks, hasLength(2));
      expect(restored.subtasks.first.title, 'one');
      expect(restored.subtasks.first.isComplete, isTrue);
      expect(restored.completedSubtasks, 1);
      expect(restored.hasSubtasks, isTrue);
    });

    test('empty subtasks persist as null and tolerate garbage', () {
      const task = Task(title: 'a', isComplete: false, updatedAt: '');
      expect(task.toMap()['subtasks'], isNull);
      expect(Subtask.decode(null), isEmpty);
      expect(Subtask.decode('not json'), isEmpty);
    });
  });

  group('NoteBackground', () {
    test('solid + gradient tokens round-trip', () {
      final solidToken = NoteBackground.solid(const Color(0xFFFFF1B8)).token;
      expect(NoteBackground.fromToken(solidToken).token, solidToken);

      final g = NoteBackground.gradients.first;
      expect(NoteBackground.fromToken('g:${g.id}').token, 'g:${g.id}');

      expect(NoteBackground.fromToken('img:bg_1.jpg').isImage, isTrue);
      expect(NoteBackground.fromToken(null).isNone, isTrue);
    });

    test('legacy color int maps to a solid background token', () {
      final note =
          Note.fromMap({'task': null, 'note': 'x', 'color': 0xFFFFF1B8});
      final bg = NoteBackground.fromToken(note.background);
      expect(bg.type, NoteBgType.solid);
    });

    test('light background gets dark text, dark background gets light text',
        () {
      const scheme = ColorScheme.light();
      final light = NoteBackground.solid(const Color(0xFFFFF1B8));
      final dark = NoteBackground.gradient(
        NoteBackground.gradients.firstWhere((g) => g.id == 'night'),
      );
      // Light surface -> dark text is darker than light surface -> light text.
      expect(light.primaryText(scheme, Brightness.light).computeLuminance(),
          lessThan(0.5));
      expect(dark.primaryText(scheme, Brightness.light).computeLuminance(),
          greaterThan(0.5));
    });
  });
}
