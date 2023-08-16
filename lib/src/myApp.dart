import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';

import 'package:note/src/features/Note/presentation/bloc/crud_bloc.dart';
import 'package:note/src/features/Note/presentation/cubit/background_color_cubit.dart';
import 'package:note/src/features/Note/presentation/cubit/fontsize_cubit.dart';
import 'package:note/src/features/Note/presentation/cubit/isupdate_cubit.dart';
import 'package:note/src/features/Note/presentation/view/widget/addnote.dart';

import 'package:note/src/features/Task/data/repositories/task_repository_imp.dart';
import 'package:note/src/features/Task/domain/usecase/add_task.dart';
import 'package:note/src/features/Task/domain/usecase/get_all_task.dart';
import 'package:note/src/features/Task/presentation/bloc/cubit/controller_cubit.dart';
import 'package:note/src/features/Task/presentation/bloc/task_bloc.dart';

import 'package:note/src/features/home/homeScreen.dart';

import '../generated/l10n.dart';

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
          create: (context) => IsupdateCubit(),
        ),
        BlocProvider(
          create: (context) => ControllerCubit(),
        ),
        BlocProvider(
          create: (context) => FontsizeCubit(),
        ),
        BlocProvider(create: (context) => BackgroundColorCubit()),
        BlocProvider(
          create: (context) => TaskBloc(
              AddtaskUsecase(TaskRepositoryImpl(
                  LocalDataSource: NoteLocalDataSourceImpl())),
              GetAllTaskUsecase(TaskRepositoryImpl(
                  LocalDataSource: NoteLocalDataSourceImpl())))
            ..add(GetAllTaskEvent('tasks')),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xfffafafa),
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xfffafafa),
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          )),
          inputDecorationTheme:
              const InputDecorationTheme(prefixIconColor: Colors.grey),
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(
          initIndex: 0,
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(ui.PlatformDispatcher.instance.locale.languageCode),
        supportedLocales: S.delegate.supportedLocales,
        routes: {
          'HomeScreen': (context) => HomeScreen(
                initIndex: 0,
              ),
          'AddNote': (context) => Addnote(),
        },
      ),
    );
  }
}

bool isArabic() {
  return Intl.getCurrentLocale() == "er";
}
