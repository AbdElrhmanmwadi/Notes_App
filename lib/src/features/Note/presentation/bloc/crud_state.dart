part of 'crud_bloc.dart';

abstract class CrudState extends Equatable {
  const CrudState();

  @override
  List<Object> get props => [];
}

class CrudInitial extends CrudState {}

class LoadingCrud extends CrudState {}

class ErrorCrud extends CrudState {
  final String message;

  ErrorCrud({required this.message});

  @override
  List<Object> get props => [message];
}

class SuccCrud extends CrudState {
  final String message;

  SuccCrud({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingNoteState extends CrudState {}

class EmptyNoteState extends CrudState {}

class LoadedNoteState extends CrudState {
  final List<NoteModel> notes;

  LoadedNoteState({required this.notes});
  @override
  List<Object> get props => [notes];
}
