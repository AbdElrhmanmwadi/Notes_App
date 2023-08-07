// ignore_for_file: prefer_const_constructors, unused_import, camel_case_types, avoid_print, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:note/src/common/widget/bottomShettForDeleteOrShare.dart';
import 'package:note/src/common/widget/CircularProgresIndicator.dart';
import 'package:note/src/common/widget/DeleteBottomSheet.dart';
import 'package:note/src/features/Task/presentation/bloc/task_bloc.dart';
import 'package:note/src/features/Task/presentation/widget/bottomShettTask.dart';
import 'package:note/src/controller/sqlConrtoller.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/features/home/homeScreen.dart';
import 'package:note/src/sql/SqlDb.dart';
import 'package:note/src/utils/string/massage.dart';
import 'package:note/src/utils/styles.dart';

import '../../Task/data/entitis/task_model.dart';

class pageTwo extends StatefulWidget {
  const pageTwo({
    super.key,
    required this.controller,
    required this.sqlDb,
    required this.taskController,
  });

  final SqlController controller;
  final SqlDb sqlDb;

  final TextEditingController taskController;

  @override
  State<pageTwo> createState() => _pageTwoState();
}

class _pageTwoState extends State<pageTwo> {
  bool isExpandedd = true;
  List<TaskModel> completedList = [];
  List<TaskModel> incompleteList = [];

  void _onExpansionChange(bool newExpandedState) {
    setState(() {
      isExpandedd = newExpandedState;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? selectedItem;
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              Text('complet'),
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is LoadedTaskState) {
                    completedList = state.tasks
                        .where((note) => note.isComplete == 0)
                        .toList();
                    incompleteList = state.tasks
                        .where((note) => note.isComplete == 1)
                        .toList();

                    return Column(
                      children: [
                        taskwidget(
                            sqlDb: widget.sqlDb,
                            taskController: widget.taskController,
                            snapshot: incompleteList),
                        ExpansionPanelList(
                            elevation: 0,
                            children: [
                              ExpansionPanel(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                headerBuilder: (context, isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Completed ${completedList.length} ',
                                    ),
                                  );
                                },
                                body: taskwidget(
                                    sqlDb: widget.sqlDb,
                                    taskController: widget.taskController,
                                    snapshot: completedList),
                                isExpanded: isExpandedd,
                              )
                            ],
                            expansionCallback: (panelIndex, isExpanded) {
                              _onExpansionChange(!isExpanded);

                              panelIndex = 0;
                            }),
                      ],
                    );
                  } else if (state is LoadingTaskState) {
                    print('loading');
                    return CircularProgresIndicator();
                  } else if (state is EmptyTaskState) {
                    return Text('Error');
                  }
                  return Container();
                },
              ),
            ])));
  }
}

class taskwidget extends StatefulWidget {
  final snapshot;
  const taskwidget({
    super.key,
    required this.sqlDb,
    required this.taskController,
    required this.snapshot,
  });

  final SqlDb sqlDb;
  final TextEditingController taskController;

  @override
  State<taskwidget> createState() => _taskwidgetState();
}

class _taskwidgetState extends State<taskwidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.snapshot.length,
      itemBuilder: (context, index) => Card(
        elevation: .5,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        child: GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return bottomShettForDeleteOrShare(
                  Widgett: deleteBottomSeet(
                    function: () async {
                      BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(
                          'tasks', 'id=${widget.snapshot[index].id}'));
                      // Navigator.of(context).pop(2);

                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HomeScreen(
                              initIndex: 1,
                            ); // The page you're navigating to
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    sqlDb: widget.sqlDb,
                  ),
                  sqlDb: widget.sqlDb,
                );
              },
            );
          },
          onTap: () {
            showModalBottomSheet(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: bottomShettTask(
                    taskController: widget.taskController,
                    sqlDb: widget.sqlDb,
                    initValue: widget.snapshot[index].task,
                    onPressed: () async {
                      BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(
                        'tasks',
                        'id=${widget.snapshot[index].id}',
                        {
                          'task': "${widget.taskController.text}",
                        },
                      ));
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
          child: InputDecorator(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15))),
            child: CheckboxListTile(
              selected: widget.snapshot[index].isComplete == 0 ? true : false,
              checkColor: Colors.white,
              activeColor: Colors.amber,
              title: Text('${widget.snapshot[index].task}'),
              value: widget.snapshot[index].isComplete == 0 ? true : false,
              onChanged: (bool? newValue) {
                int val = newValue == true ? 0 : 1;
                setState(() {
                  widget.snapshot[index].isComplete = val;
                });

                Future.delayed(Duration(seconds: 1), () {
                  BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(
                    'tasks',
                    'id=${widget.snapshot[index].id}',
                    {'isComplete': val},
                  ));
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ),
      ),
    );
  }
}

// SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           children: [
//             Text('complet'),
//             BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
//               if (state is LoadedTaskState) {
//                 final completedList =
//                     state.tasks.where((note) => note.isComplete == 1).toList();
//                 final incompleteList =
//                     state.tasks.where((note) => note.isComplete == 0).toList();

//                 return Column(
//                   children: [
//                     // ListTile(
//                     //   title: Text('Completed ${completedList.length}'),
//                     //   leading: false
//                     //       ? Icon(Icons.arrow_drop_up)
//                     //       : Icon(Icons.arrow_drop_down),
//                     //   onTap: () {
//                     //     BlocProvider.of<TaskBloc>(context).toggleExpansion();
//                     //   },
//                     // ),
//                     // if (state is Expando)
//                     //   taskwidget(
//                     //     sqlDb: widget.sqlDb,
//                     //     taskController: widget.taskController,
//                     //     snapshot: completedList,
//                     //   ),
//                     // taskwidget(
//                     //   sqlDb: widget.sqlDb,
//                     //   taskController: widget.taskController,
//                     //   snapshot: incompleteList,
//                     // ),
//                   ],
//                 );
//               } else if (state is LoadingTaskState) {
//                 return CircularProgresIndicator();
//               } else if (state is EmptyTaskState) {
//                 return Text('Error');
//               }
//               return Container();
//             }),
//           ],
//         ),
//       ),
//     );



//  GetBuilder<SqlController>(
//                   init: SqlController(),
//                   builder: (context) => FutureBuilder(
//                         future: controller.readData('tasks', 'isComplete=1'),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             return taskwidget(
//                               sqlDb: sqlDb,
//                               taskController: taskController,
//                               snapshot: snapshot,
//                             );
//                           } else {
//                             return CircularProgresIndicator();
//                           }
//                         },
//                       )),
//               GetBuilder<SqlController>(
//                   init: SqlController(),
//                   builder: (context) => FutureBuilder(
//                         future: controller.readData('tasks', 'isComplete=0'),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasData) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Column(
//                                   children: [
//                                     ListTile(
                                     
//                                       title: Text(
//                                         'Completed ${snapshot.data.length} ',
//                                       ),
//                                       leading: isExpanded
//                                           ? Icon(Icons.arrow_drop_up)
//                                           : Icon(Icons.arrow_drop_down),
//                                       onTap: () {
//                                         isExpanded = !isExpanded;
//                                       },
//                                     ),
//                                     if (isExpanded)
//                                       taskwidget(
//                                         sqlDb: sqlDb,
//                                         taskController: taskController,
//                                         snapshot: snapshot,
//                                       ),
//                                   ],
//                                 ),
//                               ],
//                             );
//                           } else {
//                             return CircularProgresIndicator();
//                           }
//                         },
//                       )),