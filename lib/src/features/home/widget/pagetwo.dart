// ignore_for_file: prefer_const_constructors, unused_import, camel_case_types, avoid_print, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/src/common/widget/bottomShettForDeleteOrShare.dart';
import 'package:note/src/common/widget/CircularProgresIndicator.dart';
import 'package:note/src/common/widget/DeleteBottomSheet.dart';
import 'package:note/src/common/widget/bottomShettForDeleteOrShare.dart';
import 'package:note/src/features/Task/widget/bottomShettTask.dart';
import 'package:note/src/controller/sqlConrtoller.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/features/home/homeScreen.dart';
import 'package:note/src/sql/SqlDb.dart';
import 'package:note/src/utils/styles.dart';

class pageTwo extends StatelessWidget {
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
  Widget build(BuildContext context) {
    bool isExpanded = false;
    String? selectedItem;
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              Text('complet'),
              GetBuilder<SqlController>(
                  init: SqlController(),
                  builder: (context) => FutureBuilder(
                        future: controller.readData('tasks', 'isComplete=1'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return taskwidget(
                              sqlDb: sqlDb,
                              taskController: taskController,
                              snapshot: snapshot,
                            );
                          } else {
                            return CircularProgresIndicator();
                          }
                        },
                      )),
              GetBuilder<SqlController>(
                  init: SqlController(),
                  builder: (context) => FutureBuilder(
                        future: controller.readData('tasks', 'isComplete=0'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    ListTile(
                                     
                                      title: Text(
                                        'Completed ${snapshot.data.length} ',
                                      ),
                                      leading: isExpanded
                                          ? Icon(Icons.arrow_drop_up)
                                          : Icon(Icons.arrow_drop_down),
                                      onTap: () {
                                        isExpanded = !isExpanded;
                                      },
                                    ),
                                    if (isExpanded)
                                      taskwidget(
                                        sqlDb: sqlDb,
                                        taskController: taskController,
                                        snapshot: snapshot,
                                      ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return CircularProgresIndicator();
                          }
                        },
                      )),
            ])));
  }
}

class taskwidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) => Card(
        elevation: .5,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        child: GestureDetector(
          onLongPress: () {
            Get.bottomSheet(
                barrierColor: Colors.transparent,
                bottomShettForDeleteOrShare(
                  sqlDb: sqlDb,
                  Widgett: deleteBottomSeet(
                    sqlDb: sqlDb,
                    function: () async {
                      await sqlDb.delete(
                          'tasks', 'id=${snapshot.data[index]['id']}');

                      Get.offAll(HomeScreen(
                        initIndex: 1,
                      ));
                    },
                  ),
                ));
          },
          onTap: () {
            Get.bottomSheet(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: bottomShettTask(
                  taskController: taskController,
                  sqlDb: sqlDb,
                  initValue: snapshot.data[index]['task'],
                  onPressed: () async {
                    var response = await sqlDb.update(
                        'tasks',
                        {
                          'task': "${taskController.text}",
                        },
                        'id=${snapshot.data[index]['id']}');
                    print(response);
                    if (response > 0) {
                      Get.back();
                    }
                  },
                ),
              ),
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
              selected: snapshot.data[index]['isComplete'] == 0 ? true : false,
              checkColor: Colors.white,
              activeColor: Colors.amber,
              title: Text('${snapshot.data[index]['task']}'),
              value: snapshot.data[index]['isComplete'] == 0 ? true : false,
              onChanged: (bool? newValue) {
                int val = newValue == true ? 0 : 1;
                sqlDb.update('tasks', {'isComplete': val},
                    'id=${snapshot.data[index]['id']}');
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ),
      ),
    );
  }
}
