import 'package:note/src/features/Task/domain/repositories/task_repository.dart';

class UpdateTaskUsecase {
  final TaskRepository repository;

  UpdateTaskUsecase(this.repository);
  Future call(String table, Map<String, Object?> value, String? myWhere) async {
    return await repository.updateTask(table, value, myWhere);
  }
}
