import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note/src/features/Note/data/entitis/note_model.dart';
import 'package:note/src/features/Note/data/repositories/note_repository_imp.dart';

import '../../data/datasources/local/note_local_data_source.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(NoteInitial()) {
    on<NoteEvent>((event, emit) async {
      if (event is GetAllNoteEvent) {
        print('2222222222222');
        emit(LoadingNoteState());
        print('222222222222r');
        final List<NoteModel> data =
            await NoteRepositoryImpl(LocalDataSource: NoteLocalDataSourceImpl())
                .getAllNote('notes', '1');

        print('${data} 1111111111111111111111111111111111111');
        emit(LoadedNoteState(notes: data));
      }
    });
  }
}
