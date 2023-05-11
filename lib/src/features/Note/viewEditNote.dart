// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, unnecessary_string_interpolations, avoid_print, unused_import, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note/src/controller/addNoteController.dart';
import 'package:note/src/controller/sqlConrtoller.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/features/home/homeScreen.dart';
import 'package:note/src/sql/SqlDb.dart';
import 'package:note/src/utils/styles.dart';

class viewEditNote extends StatelessWidget {
  final String title, body;
  final id;
  viewEditNote({
    Key? key,
    required this.title,
    required this.body,
    required this.id,
  }) : super(key: key);

  final SqlDb sqlDb = SqlDb();

  SqlController sqlController = SqlController();

  TextEditingController titleController = TextEditingController();

  TextEditingController bodyController = TextEditingController();

  // SqlController controller =Get.put(SqlController());
  @override
  Widget build(BuildContext context) {
    ViewNoteController controller = Get.put(ViewNoteController());
    SqlController sqlcontroller = Get.put(sqlController);
    titleController.text = title;
    bodyController.text = body;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(
          color: Colors.black,
          onPressed: () async {
            var response = await sqlDb.update(
                'notes',
                {
                  'note': "${bodyController.text}",
                  'title': "${titleController.text}",
                  'date': "${DateFormat.MMMEd().format(DateTime.now())}",
                },
                'id=$id');
            print(response);
            if (response > 0) {
              Get.to(HomeScreen(
                initIndex: 0,
              ));
            }
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.color_lens_rounded,
                color: Colors.black,
              )),
          Obx(
            () => controller.isShow()
                ? IconButton(
                    onPressed: () async {
                      controller.isShow.value = false;
                    },
                    icon: Icon(
                      Icons.check,
                      size: 30,
                      color: Colors.black,
                    ))
                : Container(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                onTap: () => controller.isShow.value = true,
                onTapOutside: (event) => controller.isShow.value = false,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: robotoRegular.copyWith(
                      fontSize: 22, color: Colors.black45),
                  border: InputBorder.none,
                ),
              ),
              TextFormField(
                keyboardAppearance: Brightness.light,
                onTap: () => controller.isShow.value = true,
                onTapOutside: (event) {
                  controller.isShow.value = false;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: bodyController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                maxLines: null,
                maxLength: 1000,
                buildCounter: (context,
                    {required currentLength,
                    required isFocused,
                    required maxLength}) {
                  return Row(
                    children: [
                      Text(
                        '${DateFormat('MMM d  h:mm a').format(DateTime.now())}',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Colors.black38),
                      ),
                      Text(
                        '  |  ',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Colors.black26),
                      ),
                      Text(
                        '$currentLength Characters',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Colors.black38),
                      ),
                    ],
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Start typing',
                  hintStyle: robotoRegular.copyWith(
                      fontSize: 17, color: Colors.black45),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
