import 'package:note/src/features/Note/domain/repositories/note_repository.dart';

class GetAllNoteUsecase {
  final NoteRepository repository;

  GetAllNoteUsecase(this.repository);
  Future call(String table, myWhere) async {
    return await repository.getAllNote(table, myWhere);
  }
}
