part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class AddTaskEvent extends TaskEvent {
  final String table;

  final Map<String, Object?> value;

  AddTaskEvent(
    this.table,
    this.value,
  );
  @override
  List<Object> get props => [
        table,
        value,
      ];
}

class DeleteTaskEvent extends TaskEvent {
  final String table;
  final String myWhere;

  DeleteTaskEvent(this.table, this.myWhere);
  @override
  List<Object> get props => [table, myWhere];
}

class GetAllTaskEvent extends TaskEvent {
  final String table;

  GetAllTaskEvent(this.table);
  @override
  List<Object> get props => [table];
}

class UpdateTaskEvent extends TaskEvent {
  final String table;
  Map<String, Object?> value;
  final String? myWhere;

  UpdateTaskEvent(this.table, this.myWhere, this.value);
  @override
  List<Object> get props => [table, value, myWhere!];
}
class ToggleExpansionEvent extends TaskEvent {}



