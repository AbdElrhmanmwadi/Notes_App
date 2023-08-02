import 'package:note/src/features/Note/domain/entities/Note.dart';
import 'package:note/src/features/Note/domain/repositories/note_repository.dart';

class AddNoteRepository {
  final NoteRepository repository;

  AddNoteRepository(this.repository);
  Future call(String table, Map<String, Object?> value) async {
    return await repository.addNote(table,value);
  }
}
