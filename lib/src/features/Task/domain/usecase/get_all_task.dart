import 'package:note/src/features/Task/domain/repositories/task_repository.dart';

class GetAllTaskUsecase {
  final TaskRepository repository;

  GetAllTaskUsecase(this.repository);
  Future call(String table) async {
    return await repository.getAllTask(table);
  }
}
