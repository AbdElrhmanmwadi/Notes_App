// ignore_for_file: prefer_const_constructors, unused_import, camel_case_types, avoid_print, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:note/generated/l10n.dart';
import 'package:note/src/common/widget/bottomShettForDeleteOrShare.dart';
import 'package:note/src/common/widget/CircularProgresIndicator.dart';
import 'package:note/src/common/widget/DeleteBottomSheet.dart';
import 'package:note/src/features/Task/presentation/bloc/task_bloc.dart';
import 'package:note/src/features/Task/presentation/widget/bottomShettTask.dart';

import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/features/home/homeScreen.dart';
import 'package:note/src/utils/string/massage.dart';
import 'package:note/src/utils/styles.dart';

import '../../data/entitis/task_model.dart';

class pageTwo extends StatefulWidget {
  const pageTwo({
    super.key,
   
    required this.taskController,
  });



  final TextEditingController taskController;

  @override
  State<pageTwo> createState() => _pageTwoState();
}

class _pageTwoState extends State<pageTwo> {
  bool isExpandedd = false;
  List<TaskModel> completedList = [];
  List<TaskModel> incompleteList = [];

  void _onExpansionChange(bool newExpandedState) {
    setState(() {
      isExpandedd = newExpandedState;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
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
                                      '${S.of(context).Completed} ${NumberFormat.decimalPattern('ar').format(completedList.length)} ',
                                    ),
                                  );
                                },
                                body: taskwidget(
                                   
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
   
    required this.taskController,
    required this.snapshot,
  });

  
  final TextEditingController taskController;

  @override
  State<taskwidget> createState() => _taskwidgetState();
}

class _taskwidgetState extends State<taskwidget> {
  int isComplet = 1;
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
        child: InkWell(
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
                    
                  ),
               
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
                   
                    initValue: widget.snapshot[index].task,
                    onPressed: () async {
                      context.read<TaskBloc>().add(UpdateTaskEvent(
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
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15))),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.amber,
                    value:
                        widget.snapshot[index].isComplete == 0 ? true : false,
                    onChanged: (_) {
                      int val = widget.snapshot[index].isComplete == 0 ? 1 : 0;
                      setState(() {
                        widget.snapshot[index].isComplete = val;
                        isComplet = val;
                      });

                      Future.delayed(Duration(seconds: 1), () {
                        BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(
                          'tasks',
                          'id=${widget.snapshot[index].id}',
                          {'isComplete': val},
                        ));
                      });
                    }, // Keep onChanged as an empty function
                  ),
                ),
                Expanded(
                  child: Text(
                    '${widget.snapshot[index].task}',
                    style: isComplet == 0
                        ? TextStyle(decoration: TextDecoration.lineThrough)
                        : TextStyle(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
