// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/src/controller/sqlConrtoller.dart';
import 'package:note/src/controller/taskController.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/sql/SqlDb.dart';
import 'package:note/src/utils/styles.dart';

class bottomShettTask extends StatelessWidget {
  final initValue;
  final hint;
  final onPressed;

  const bottomShettTask({
    super.key,
    required this.taskController,
    required this.sqlDb,
    this.initValue,
    this.hint,
    required this.onPressed,
  });

  final TextEditingController taskController;
  final SqlDb sqlDb;

  @override
  Widget build(BuildContext context) {
    TaskController ControllerTask = Get.put(TaskController());
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              initialValue: initValue,
              onChanged: (value) {
                taskController.text = value;
                value.isEmpty
                    ? ControllerTask.desble.value == false
                    : ControllerTask.desble.value = true;
              },
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
              maxLines: 5,
              decoration: InputDecoration(
                prefixIconConstraints: BoxConstraints.tight(Size(10, 10)),
                hintText: hint,
                hintStyle:
                    robotoRegular.copyWith(fontSize: 16, color: Colors.black45),
                border: InputBorder.none,
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          backgroundColor: Colors.grey.withOpacity(.2),
                          foregroundColor: Colors.black),
                      onPressed: () {},
                      icon: Icon(Icons.lock_clock),
                      label: Text(
                        'Set reminder',
                        style: robotoMedium,
                      )),
                  OutlinedButton(
                      onPressed:
                          ControllerTask.desble.value ? onPressed : () {},
                      style: OutlinedButton.styleFrom(
                          disabledForegroundColor: Colors.grey,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(side: BorderSide.none)),
                      child: Text(
                        'Done',
                        style: robotoMedium.copyWith(
                            color: ControllerTask.desble.value
                                ? Colors.amber
                                : Colors.grey,
                            fontSize: Dimensions.fontSizeLarge),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
