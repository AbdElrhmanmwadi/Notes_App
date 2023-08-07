import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';
import 'package:note/src/features/Task/data/entitis/task_model.dart';
import 'package:note/src/features/Task/data/repositories/task_repository_imp.dart';
import 'package:note/src/features/Task/domain/usecase/add_task.dart';

import 'package:note/src/features/Task/domain/usecase/get_all_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  bool _isExpanded = true; // Add this line

  final AddtaskUsecase addNoteUsecase;

  final GetAllTaskUsecase getAllTaskUsecase;

  TaskBloc(
    this.addNoteUsecase,
    this.getAllTaskUsecase,
  ) : super(TaskInitial()) {
    on<TaskEvent>((event, emit) async {
      // if (event is ToggleExpansionEvent) {
      //   _isExpanded = !_isExpanded;
      //   emit(state); // Emit the same state to trigger a UI update
      // }

      if (event is AddTaskEvent) {
        emit(LoadingTaskState());
        print('loading add');

        final addTask = await addNoteUsecase(event.table, event.value);

        if (addTask > 0) {
          add(GetAllTaskEvent(
            'tasks',
          ));
        } else {
          emit(ErrorTask(message: 'Error'));
        }
      }

      if (event is DeleteTaskEvent) {
        emit(LoadingTaskState());
        final deleteTask =
            await TaskRepositoryImpl(LocalDataSource: NoteLocalDataSourceImpl())
                .deleteTask(event.table, event.myWhere);
        if (deleteTask > 0) {
          try {
            add(GetAllTaskEvent(
              'tasks',
            ));
          } catch (e) {
            print('$e errorrrrrrrrrrrrrrrrrrrrr');
            emit(EmptyTaskState());
            // Handle the error gracefully...
          }
        } else {
          emit(ErrorTask(message: 'Error'));
        }
      }

      if (event is UpdateTaskEvent) {
        emit(LoadingTaskState());
        print('loading update');
        final updateTask =
            await TaskRepositoryImpl(LocalDataSource: NoteLocalDataSourceImpl())
                .updateTask(event.table, event.value, event.myWhere);
        if (updateTask > 0) {
          try {
            add(GetAllTaskEvent(
              'tasks',
            ));
          } catch (e) {
            print('$e errorrrrrrrrrrrrrrrrrrrrr');
            emit(EmptyTaskState());
            // Handle the error gracefully...
          }
        } else {
          emit(ErrorTask(message: 'Error'));
        }
      }

      if (event is GetAllTaskEvent) {
        emit(LoadingTaskState());

        try {
          final List<TaskModel> data = await getAllTaskUsecase(
            event.table,
          );
          print('$data get All task');
          emit(LoadedTaskState(tasks: data));
        } catch (e) {
          print('$e errorrrrrrrrrrrrrrrrrrrrr');
          emit(EmptyTaskState());
        }
      }
    });
  }
  void toggleExpansion() {
    add(ToggleExpansionEvent());
  }
}













// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';
// import 'package:note/src/features/Task/data/entitis/task_model.dart';
// import 'package:note/src/features/Task/data/repositories/task_repository_imp.dart';
// import 'package:note/src/features/Task/domain/usecase/add_task.dart';
// import 'package:note/src/features/Task/domain/usecase/delete_task.dart';
// import 'package:note/src/features/Task/domain/usecase/get_all_task.dart';
// import 'package:note/src/features/Task/domain/usecase/update_task.dart';

// part 'task_event.dart';
// part 'task_state.dart';

// class TaskBloc extends Bloc<TaskEvent, TaskState> {
//   final AddtaskUsecase addNoteUsecase;

//   final GetAllTaskCompletUsecase getAllTaskUsecase;

//   TaskBloc(
//     this.addNoteUsecase,
//     this.getAllTaskUsecase,
//   ) : super(TaskInitial()) {
//     on<TaskEvent>((event, emit) async {
//       if (event is AddTaskEvent) {
//         emit(LoadingTaskState());
//         print('loading add');

//         final addTask = await addNoteUsecase(event.table, event.value);

//         if (addTask > 0) {
//           try {
//             final List<TaskModel> data = await TaskRepositoryImpl(
//                     LocalDataSource: NoteLocalDataSourceImpl())
//                 .getAllTask('tasks', 'isComplete=0');
//             print('$data Add');
//             emit(LoadedTaskState(tasks: data));
//           } catch (e) {
//             print('$e errorrrrrrrrrrrrrrrrrrrrr');
//             emit(EmptyTaskState());
//           }
//         } else {
//           emit(ErrorTask(message: 'Error'));
//         }
//       }

//       if (event is DeleteTaskEvent) {
//         emit(LoadingTaskState());
//         final deleteTask =
//             await TaskRepositoryImpl(LocalDataSource: NoteLocalDataSourceImpl())
//                 .deleteTask(event.table, event.myWhere);
//         if (deleteTask > 0) {
//           try {
//             final List<TaskModel> data = await TaskRepositoryImpl(
//                     LocalDataSource: NoteLocalDataSourceImpl())
//                 .getAllTask('tasks', 'isComplete=0');
//             print('$data delete');
//             emit(LoadedTaskState(tasks: data));
//           } catch (e) {
//             print('$e errorrrrrrrrrrrrrrrrrrrrr');
//             emit(EmptyTaskState());
//             // Handle the error gracefully...
//           }
//         } else {
//           emit(ErrorTask(message: 'Error'));
//         }
//       }

//       if (event is UpdateTaskEvent) {
//         emit(LoadingTaskState());
//         print('loading update');
//         final updateTask =
//             await TaskRepositoryImpl(LocalDataSource: NoteLocalDataSourceImpl())
//                 .updateTask(event.table, event.value, event.myWhere);
//         if (updateTask > 0) {
//           try {
//             final List<TaskModel> data = await TaskRepositoryImpl(
//                     LocalDataSource: NoteLocalDataSourceImpl())
//                 .getAllTask('tasks', 'isComplete=0');
//             print('$data Update');
//             emit(LoadedTaskState(tasks: data));
//           } catch (e) {
//             print('$e errorrrrrrrrrrrrrrrrrrrrr');
//             emit(EmptyTaskState());
//             // Handle the error gracefully...
//           }
//         } else {
//           emit(ErrorTask(message: 'Error'));
//         }
//       }

//       if (event is GetAllTaskEvent) {
//         emit(LoadingTaskState());

//         try {
//           final List<TaskModel> data = await getAllTaskUsecase(event.table,event.myWhere);
//           print('$data get All task');
//           emit(LoadedTaskState(tasks: data));
//         } catch (e) {
//           print('$e errorrrrrrrrrrrrrrrrrrrrr');
//           emit(EmptyTaskState());
//           // Handle the error gracefully...
//         }
//       }
//     });
//   }
// }
