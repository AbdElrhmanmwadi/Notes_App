// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/CircularProgresIndicator.dart';
import 'package:note/DeleteBottomSheet.dart';
import 'package:note/bottomShettForDeleteOrShare.dart';
import 'package:note/bottomShettTask.dart';
import 'package:note/controller/sqlConrtoller.dart';
import 'package:note/dimensions.dart';
import 'package:note/homeScreen.dart';
import 'package:note/sql/SqlDb.dart';
import 'package:note/styles.dart';

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
    ThemeData themeData = Theme.of(context);
    return Container(
        color: themeData.scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: GetBuilder<SqlController>(
          init: SqlController(),
          builder: (context) => FutureBuilder(
            future: controller.readData('tasks'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => FormField<bool>(
                          builder: (FormFieldState<bool> state) {
                            return Card(
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
                                            await sqlDb.delete('tasks',
                                                'id=${snapshot.data[index]['id']}');

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
                                                'task':
                                                    "${taskController.text}",
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
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  child: CheckboxListTile(
                                    selected: state.value ?? false,
                                    checkColor: Colors.white,
                                    activeColor: Colors.amber,
                                    title:
                                        Text('${snapshot.data[index]['task']}'),
                                    value: state.value ?? false,
                                    onChanged: (bool? newValue) {
                                      state.didChange(newValue);
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                ),
                              ),
                            );
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a value';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // Handle saving the form value
                          },
                        ));
              } else {
                return CircularProgresIndicator();
              }
            },
          ),
        ));
  }
}
