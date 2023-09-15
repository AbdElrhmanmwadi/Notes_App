import 'package:intl/intl.dart';
import 'package:note/src/features/Note/domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required int id,
    required String note,
    required String title,
    required DateTime date,
    required String backgroundColor,
  }) : super(
            id: id,
            note: note,
            title: title,
            date: date,
            backgroundColor: backgroundColor);

  factory NoteModel.fromMap(Map<dynamic, dynamic> map) {
    String inputDateString = map['date'];

    // Convert inputDateString to a DateTime object
    DateTime parsedDate = DateFormat.MMMEd().parse(inputDateString);
    // DateFormat.MMMEd().format(DateTime.now());

    return NoteModel(
      id: map['id'],
      note: map['note'],
      title: map['title'],
      date: parsedDate,
      backgroundColor: map['backgroundColor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note,
      'title': title,
      // 'date': date,
      'backgroundColor': backgroundColor
    };
  }
}
