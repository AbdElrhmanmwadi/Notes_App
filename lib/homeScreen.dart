// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/addnote.dart';
import 'package:note/bottomShettTask.dart';
import 'package:note/controller/sqlConrtoller.dart';
import 'package:note/pageone.dart';
import 'package:note/pagetwo.dart';
import 'package:note/sql/SqlDb.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.initIndex}) : super(key: key);
  final initIndex;
  SqlDb sqlDb = SqlDb();

  SqlController controller = Get.put(SqlController());
  TextEditingController taskController = TextEditingController();

  var pageIndex = 0;
  bool? CompletTask = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initIndex,
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.amberAccent,
          onPressed: () {
            if (pageIndex.isEven) {
              Get.to(() => Addnote());
            } else {
              Get.bottomSheet(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: bottomShettTask(
                      hint: 'Enter tap to save task',
                      taskController: taskController,
                      sqlDb: sqlDb,
                      onPressed: () async {
                        var respones = await sqlDb
                            .insert('tasks', {'task': taskController.text});
                        if (respones > 0) {
                          print(respones);
                        }
                        Get.back();
                      }),
                ),
              );
            }

            // sqlDb.deleteMyDatabase();
          },
          child: Icon(
            Icons.add,
            size: 35,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              pageIndex = value;
              print(pageIndex);
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
            pageOne(controller: controller, sqlDb: sqlDb),
            pageTwo(
                controller: controller,
                sqlDb: sqlDb,
                taskController: taskController),
          ],
        ),
      ),
    );
  }
}












