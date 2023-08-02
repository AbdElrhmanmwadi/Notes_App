part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class LoadingNoteState extends NoteState {}

class LoadedNoteState extends NoteState {
  final List<NoteModel> notes;

  LoadedNoteState({required this.notes});
   @override
  List<Object> get props => [notes];
}
