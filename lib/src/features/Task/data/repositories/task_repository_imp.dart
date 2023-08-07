import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';

import 'package:note/src/features/Task/data/entitis/task_model.dart';
import 'package:note/src/features/Task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  final NoteLocalDataSource LocalDataSource;

  TaskRepositoryImpl({required this.LocalDataSource});

  @override
  Future<int> addTask(String table, Map<String, Object?> value) async {
    final response = await LocalDataSource.addNote(table, value);
    return response;
  }

  @override
  Future<int> deleteTask(String table, String myWhere) async {
    final response = await LocalDataSource.deleteNote(table, myWhere);
    return response;
  }

  @override
  Future<int> updateTask(
      String table, Map<String, Object?> value, String? myWhere) async {
    final response = await LocalDataSource.updateNote(table, value, myWhere);
    return response;
  }

  @override
  Future<List<TaskModel>> getAllTask(String table) async {
    final response = await LocalDataSource.getAllTask(table);
    return response;
  }
}
