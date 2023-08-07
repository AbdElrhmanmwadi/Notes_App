import 'package:note/src/features/Note/domain/repositories/note_repository.dart';

class DeleteNoteUsecase {
  final NoteRepository repository;

  DeleteNoteUsecase(this.repository);
  Future call(String table, String myWhere) async {
    return await repository.deleteNote(table, myWhere);
  }
}
