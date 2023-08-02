
import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';
import 'package:note/src/features/Note/data/entitis/note_model.dart';
import 'package:note/src/features/Note/domain/repositories/note_repository.dart';

class NoteRepositoryImpl extends NoteRepository {
  final NoteLocalDataSource LocalDataSource;

  NoteRepositoryImpl({required this.LocalDataSource});

  @override
  Future<int> addNote(String table, Map<String, Object?> value) async {
    final response = await LocalDataSource.addNote(table, value);
    return response;
  }

  @override
  Future<int> deleteNote(String table, String myWhere)async {
   final response = await LocalDataSource.deleteNote(table, myWhere);
    return response;
  }




  @override
  Future<int> updateNote(
      String table, Map<String, Object?> value, String? myWhere)async {
     final response = await LocalDataSource.updateNote(table, value, myWhere);
    return response;
  }
  
  @override
  Future<List<NoteModel>> getAllNote(String table, myWhere) async{
     final response = await LocalDataSource.getAllNote(table, myWhere);
    return response;
  }
}
