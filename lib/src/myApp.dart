import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';

import 'package:note/src/features/Note/presentation/bloc/crud_bloc.dart';
import 'package:note/src/features/Note/presentation/widget/addnote.dart';
import 'package:note/src/features/Task/data/repositories/task_repository_imp.dart';
import 'package:note/src/features/Task/domain/usecase/add_task.dart';
import 'package:note/src/features/Task/domain/usecase/get_all_task.dart';
import 'package:note/src/features/Task/presentation/bloc/task_bloc.dart';

import 'package:note/src/features/home/homeScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CrudBloc()..add(GetAllNoteEvent()),
        ),
        BlocProvider(
          create: (context) => TaskBloc(
              AddtaskUsecase(TaskRepositoryImpl(
                  LocalDataSource: NoteLocalDataSourceImpl())),
              GetAllTaskUsecase(TaskRepositoryImpl(
                  LocalDataSource: NoteLocalDataSourceImpl())))
            ..add(GetAllTaskEvent('tasks')),
        ),
        // BlocProvider(create: (context) => CrudBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          inputDecorationTheme:
              const InputDecorationTheme(prefixIconColor: Colors.grey),
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(
          initIndex: 0,
        ),
        routes: {
          'HomeScreen': (context) => HomeScreen(
                initIndex: 0,
              ),
          'AddNote': (context) => const Addnote(),
        },
      ),
    );
  }
}
