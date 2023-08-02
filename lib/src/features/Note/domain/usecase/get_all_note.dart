import 'package:note/src/features/Note/domain/repositories/note_repository.dart';

class GetAllNote {
  final NoteRepository repository;

  GetAllNote(this.repository);
  Future call(String table, myWhere) async {
    return await repository.getAllNote(table, myWhere);
  }
}
