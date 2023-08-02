

import 'package:note/src/features/Note/data/entitis/note_model.dart';

abstract class NoteRepository {
 Future <List<NoteModel>> getAllNote(String table, myWhere);
 Future<int> deleteNote(String table, String myWhere);
  Future<int> updateNote(String table, Map<String, Object?> value, String? myWhere);
  Future<int> addNote(String table, Map<String, Object?> value);
  
}
