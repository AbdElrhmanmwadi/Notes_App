import 'package:note/src/features/Note/domain/repositories/note_repository.dart';

class UpdateNoteUsecase {
  final NoteRepository repository;

  UpdateNoteUsecase(this.repository);
  Future call(String table, Map<String, Object?> value, String? myWhere) async {
    return await repository.updateNote(table, value, myWhere);
  }
}
