import 'package:note/src/features/Note/domain/repositories/note_repository.dart';

class DeleteNoteRepository {
  final NoteRepository repository;
  

  DeleteNoteRepository(this.repository);
  Future call(String table, String myWhere) async {
    return await repository.deleteNote( table,  myWhere);
  }
}
