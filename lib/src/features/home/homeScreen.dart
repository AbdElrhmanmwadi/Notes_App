// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:note/generated/l10n.dart';
import 'package:note/src/features/Note/presentation/cubit/isupdate_cubit.dart';
import 'package:note/src/features/Task/presentation/bloc/task_bloc.dart';

import 'package:note/src/features/Task/presentation/widget/bottomShettTask.dart';

import 'package:note/src/features/Note/presentation/view/page/pageone.dart';
import 'package:note/src/features/Task/presentation/page/pagetwo.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.initIndex}) : super(key: key);
  final initIndex;
  

  TextEditingController taskController = TextEditingController();

  var pageIndex = 0;
  bool? CompletTask = false;
  @override
  Widget build(BuildContext context) {
    IsupdateCubit cubitisUpdate = BlocProvider.of<IsupdateCubit>(context);
    return DefaultTabController(
      initialIndex: initIndex,
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.amberAccent,
          onPressed: () {
            if (cubitisUpdate.pageInde.isEven) {
              Navigator.of(context).pushNamed('AddNote');
              // sqlDb.deleteMyDatabase();
            } else {
              showModalBottomSheet(
                context: context,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bottomShettTask(
                        hint: '${S.of(context).task_hint}',
                        taskController: taskController,
                        onPressed: () async {
                          final formattedDate =
                              DateFormat.MMMEd().format(DateTime.now());
                          print('Formatted Date: $formattedDate');

                          BlocProvider.of<TaskBloc>(context)
                              .add(AddTaskEvent('tasks', {
                            'task': taskController.text,
                            'isComplete': 1,
                          }));
                          Navigator.pop(context);
                        }),
                  );
                },
              );
            }
          },
          child: Icon(
            Icons.add,
            size: 35,
          ),
        ),
        endDrawer: Drawer(
          width: double.infinity,
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.yellow,
            indicatorColor: Colors.transparent,
            onTap: (value) {
              cubitisUpdate.pageIndex(value);
              print(value);
            },
            tabs: [
              Icon(
                Icons.note_alt_outlined,
              ),
              Icon(
                Icons.check_box_outlined,
              ),
            ],
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.settings,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    color: Colors.grey,
                  ),
                ))
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          children: [
            pageOne(),
            pageTwo(taskController: taskController),
          ],
        ),
      ),
    );
  }
}
