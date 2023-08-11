import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:note/src/features/Note/data/entitis/note_model.dart';

import 'package:note/src/features/Note/data/repositories/note_repository_imp.dart';
import 'package:note/src/features/Note/presentation/view/widget/addnote.dart';

import '../../data/datasources/local/note_local_data_source.dart';

part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  // final AddNoteUsecase AddNoteUsecase;
  // final UpdateNoteUsecase UpdateNoteUsecase;
  // final DeleteNoteUsecase DeleteNoteUsecase;

  CrudBloc(
      // this.AddNoteUsecase, this.UpdateNoteUsecase,
      //   this.DeleteNoteUsecase
      )
      : super(CrudInitial()) {
    on<CrudEvent>((event, emit) async {
      if (event is AddNoteEvent) {
        emit(LoadingNoteState());
        print('loading add');

        final Addnote =
            await NoteRepositoryImpl(LocalDataSource: NoteLocalDataSourceImpl())
                .addNote(event.table, event.value);
        if (Addnote > 0) {
          try {
            final List<NoteModel> data = await NoteRepositoryImpl(
              LocalDataSource: NoteLocalDataSourceImpl(),
            ).getAllNote('notes', '');
            print('${data}, add');
            emit(LoadedNoteState(notes: data));
          } catch (e) {
            print(" eeeeeeeeeeeeeeeeeee $e");
            emit(EmptyNoteState());
            // Handle the error gracefully...
          }
        } else {
          emit(ErrorCrud(message: 'Error'));
        }
      }

      if (event is DeleteNoteEvent) {
        emit(LoadingNoteState());
        final deleteNote =
            await NoteRepositoryImpl(LocalDataSource: NoteLocalDataSourceImpl())
                .deleteNote(event.table, event.myWhere);
        if (deleteNote > 0) {
          try {
            final List<NoteModel> data = await NoteRepositoryImpl(
              LocalDataSource: NoteLocalDataSourceImpl(),
            ).getAllNote('notes', '');
            print('${data} delete');
            emit(LoadedNoteState(notes: data));
          } catch (e) {
            emit(EmptyNoteState());
          }
        } else {
          emit(ErrorCrud(message: 'Error'));
        }
      }

      if (event is UpdateNoteEvent) {
        emit(LoadingNoteState());
        print('loading update');
        final updateNote =
            await NoteRepositoryImpl(LocalDataSource: NoteLocalDataSourceImpl())
                .updateNote(event.table, event.value, event.myWhere);
        if (updateNote > 0) {
          try {
            final List<NoteModel> data = await NoteRepositoryImpl(
              LocalDataSource: NoteLocalDataSourceImpl(),
            ).getAllNote('notes', '');
            emit(LoadedNoteState(notes: data));
          } catch (e) {
            emit(EmptyNoteState());
            // Handle the error gracefully...
          }
        } else {
          emit(ErrorCrud(message: 'Error'));
        }
      }

      if (event is GetAllNoteEvent) {
        emit(LoadingNoteState());

        try {
          final List<NoteModel> data = await NoteRepositoryImpl(
            LocalDataSource: NoteLocalDataSourceImpl(),
          ).getAllNote('notes', '');
          emit(LoadedNoteState(notes: data));
        } catch (e) {
          emit(EmptyNoteState());
        }
      }
    });
  }
}
