import 'package:note/src/features/Task/domain/repositories/task_repository.dart';

class DeleteTaskUsecase {
  final TaskRepository repository;

  DeleteTaskUsecase(this.repository);
  Future call(String table, String myWhere) async {
    return await repository.deleteTask(table, myWhere);
  }
}
