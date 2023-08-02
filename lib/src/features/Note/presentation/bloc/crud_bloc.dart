import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note/src/features/Note/domain/usecase/add_note.dart';
import 'package:note/src/features/Note/domain/usecase/delete_note.dart';
import 'package:note/src/features/Note/domain/usecase/update_note.dart';
import 'package:note/src/features/Note/presentation/widget/addnote.dart';

part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  final AddNoteRepository addNoteRepository;
  final UpdateNoteRepository updateNoteRepository;
  final DeleteNoteRepository deleteNoteRepository;

  CrudBloc(this.addNoteRepository, this.updateNoteRepository,
      this.deleteNoteRepository)
      : super(CrudInitial()) {
    on<CrudEvent>((event, emit) async {
      if (event is AddNoteEvent) {
        emit(LoadingCrud());
        final Addpost = await addNoteRepository.call(event.table, event.value);
        if (Addpost > 0) {
          emit(SuccCrud(message: 'Add Note'));
        } else {
          emit(ErrorCrud(message: 'Error'));
        }
      } else if (event is DeleteNoteEvent) {
        emit(LoadingCrud());
        final deleteNote =
            await deleteNoteRepository.call(event.table, event.myWhere);
        if (deleteNote > 0) {
          emit(SuccCrud(message: 'Delete Note'));
        } else {
          emit(ErrorCrud(message: 'Error'));
        }
      } else if (event is UpdateNoteEvent) {
        final updateNote = await updateNoteRepository.call(
            event.table, event.value, event.myWhere);
        if (updateNote > 0) {
          emit(SuccCrud(message: 'update Note'));
        } else {
          emit(ErrorCrud(message: 'Error'));
        }
      }
    });
  }
}
