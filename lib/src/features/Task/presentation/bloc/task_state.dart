part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class LoadingCrud extends TaskState {}

class ErrorTask extends TaskState {
  final String message;

  ErrorTask({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccTask extends TaskState {
  final String message;

  SuccTask({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingTaskState extends TaskState {}

class EmptyTaskState extends TaskState {}

class LoadedTaskState extends TaskState {
  final List<TaskModel> tasks;

  LoadedTaskState({required this.tasks});
  @override
  List<Object> get props => [tasks];
}
