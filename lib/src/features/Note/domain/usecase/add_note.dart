import 'package:note/src/features/Note/domain/repositories/note_repository.dart';

class AddNoteUsecase {
  final NoteRepository repository;

  AddNoteUsecase(this.repository);
  Future call(String table, Map<String, Object?> value) async {
    return await repository.addNote(table, value);
  }
}
