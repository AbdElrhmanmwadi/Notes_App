part of 'crud_bloc.dart';

abstract class CrudEvent extends Equatable {
  const CrudEvent();

  @override
  List<Object> get props => [];
}

class AddNoteEvent extends CrudEvent {
  final String table;

  final Map<String, Object?> value;

  AddNoteEvent(this.table, this.value);
  @override
  List<Object> get props => [table, value];
}

class DeleteNoteEvent extends CrudEvent {
  final String table;
  final String myWhere;

  DeleteNoteEvent(this.table, this.myWhere);
  @override
  List<Object> get props => [table, myWhere];
}

class GetAllNoteEvent extends CrudEvent {}

class UpdateNoteEvent extends CrudEvent {
  final String table;
  Map<String, Object?> value;
  final String? myWhere;

  UpdateNoteEvent(this.table, this.myWhere, this.value);
  @override
  List<Object> get props => [table, value, myWhere!];
}
