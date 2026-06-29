// Unit tests for the model mapping layer. These cover the data conversions
// that the old code got wrong (notably the inverted task-completion flag and
// the column<->field naming), without requiring the sqflite plugin.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note/src/core/theme/note_background.dart';
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
