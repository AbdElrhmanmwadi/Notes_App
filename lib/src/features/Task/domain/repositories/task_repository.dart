import 'package:note/src/features/Task/data/entitis/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTask(String table);
  Future<int> deleteTask(String table, String myWhere);
  Future<int> updateTask(
      String table, Map<String, Object?> value, String? myWhere);
  Future<int> addTask(String table, Map<String, Object?> value);
}
