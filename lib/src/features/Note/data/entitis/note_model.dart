import 'package:intl/intl.dart';
import 'package:note/src/features/Note/domain/entities/Note.dart';

class NoteModel extends Note {
  NoteModel({
    required int id,
    required String note,
    required String title,
    required DateTime date,
  }) : super(id: id, note: note, title: title, date: date);

  factory NoteModel.fromMap(Map<dynamic, dynamic> map) {
    String inputDateString = map['date'];

    // Convert inputDateString to a DateTime object
    DateTime parsedDate = DateFormat('EEE, MMM d').parse(inputDateString);

    return NoteModel(
      id: map['id'],
      note: map['note'],
      title: map['title'],
      date: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    String formattedDate = DateFormat('MMM d h:mm a').format(date);

    return {
      'id': id,
      'note': note,
      'title': title,
      'date': formattedDate,
    };
  }
}
