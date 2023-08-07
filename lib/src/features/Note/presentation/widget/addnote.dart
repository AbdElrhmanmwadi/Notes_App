// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, unnecessary_string_interpolations, avoid_print


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note/src/controller/addNoteController.dart';
import 'package:note/src/features/Note/presentation/bloc/crud_bloc.dart';
import 'package:note/src/utils/dimensions.dart';

import 'package:note/src/sql/SqlDb.dart';
import 'package:note/src/utils/styles.dart';
import 'package:note/src/common/widget/willPopDialog.dart';

var sumLength = 0;

class Addnote extends StatefulWidget {
  const Addnote({
    Key? key,
  }) : super(key: key);

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  final SqlDb sqlDb = SqlDb();
  bool _canPop = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  // SqlController controller =Get.put(SqlController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ViewNoteController controller = Get.put(ViewNoteController());
    return WillPopScope(
      onWillPop: () async {
        if (controller.canPop.value) {
          return true;
        } else {
          showDialog(context: context, builder: (context) => WillPopDialog());
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () async {
              BlocProvider.of<CrudBloc>(context).add(AddNoteEvent('notes', {
                'note': "${bodyController.text}",
                'title': "${titleController.text}",
                'date': "${DateFormat.MMMEd().format(DateTime.now())}",
              }));

             
             
              Navigator.of(context).pop();

              // var response = await sqlDb.insert('notes', {
              //   'note': "${bodyController.text}",
              //   'title': "${titleController.text}",
              //   'date': "${DateFormat.MMMEd().format(DateTime.now())}",
              // });
              // print(response);
              // if (response > 0) {
              //   print('insaret');
              //   Get.to(HomeScreen(
              //     initIndex: 0,
              //   ));
              // }
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
      ),
    );
  }
}
