import 'package:note/src/features/Task/domain/repositories/task_repository.dart';

class AddtaskUsecase {
  final TaskRepository repository;

  AddtaskUsecase(this.repository);
  Future call(String table, Map<String, Object?> value) async {
    return await repository.addTask(table, value);
  }
}
