// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, unnecessary_string_interpolations, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note/generated/l10n.dart';
import 'package:note/src/common/fuction/function..dart';
import 'package:note/src/common/listColor.dart';
import 'package:note/src/common/widget/bottomSheetColor.dart';
import 'package:note/src/features/Note/presentation/bloc/crud_bloc.dart';
import 'package:note/src/features/Note/presentation/cubit/background_color_cubit.dart';
import 'package:note/src/features/Note/presentation/cubit/isupdate_cubit.dart';
import 'package:note/src/utils/dimensions.dart';

import 'package:note/src/utils/styles.dart';

var sumLength = 0;

class Addnote extends StatelessWidget {
  Addnote({
    Key? key,
  }) : super(key: key);

  TextEditingController titleController = TextEditingController();

  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    IsupdateCubit cubitisUpdate = BlocProvider.of<IsupdateCubit>(context);
    BackgroundColorCubit cubitbackground =
        BlocProvider.of<BackgroundColorCubit>(context);
    bool backroundColor = true;
    Color background = Colors.white;

    return WillPopScope(
      onWillPop: () async {
        if (cubitisUpdate.canPo) {
          return true;
        } else {
          showDialog(
              context: context,
              builder: (context) => Container(
                    child: AlertDialog(
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      backgroundColor: Colors.white38,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Center(
                          child: Icon(
                        Icons.error,
                        color: Colors.white,
                      )),
                      content: Text(
                        "${S.of(context).Areyour}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                      actions: [
                        MaterialButton(
                          color: Colors.white54,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "${S.of(context).Keep}",
                          ),
                        ),
                        MaterialButton(
                          textColor: Colors.white,
                          color: Colors.white38,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            cubitisUpdate.canPop(true);

                            Navigator.of(context).pushNamed('HomeScreen');
                            cubitisUpdate.canPop(false);
                          },
                          child: Text(
                            "${S.of(context).Discard}",
                          ),
                        ),
                      ],
                    ),
                  ));
          return false;
        }
      },
      child: BlocBuilder<BackgroundColorCubit, BackgroundColorState>(
        builder: (context, state) {
          if (state is BackgroundColorInitial) {
            Color textColor =
                getForegroundColor(backroundColor ? background : state.color);

            print(textColor);
            return Scaffold(
              backgroundColor: backroundColor ? background : state.color,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: backroundColor ? background : state.color,
                // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: textColor,
                  onPressed: () async {
                    if (bodyController.text.isNotEmpty ||
                        titleController.text.isNotEmpty) {
                      BlocProvider.of<CrudBloc>(context)
                          .add(AddNoteEvent('notes', {
                        'note': "${bodyController.text}",
                        'title': "${titleController.text}",
                        // 'date':
                        //     "${DateFormat.MMMEd('en').format(DateTime.now())}",
                        "backgroundColor": "${state.color.value}"
                      }));

                      print("${bodyController.text}");
                      print("${titleController.text}");

                      print("${state.color.value}");
                    }
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        bottomSheetColor(context, cubitbackground);
                        backroundColor = false;
                      },
                      icon: Icon(
                        Icons.color_lens_rounded,
                        color: textColor,
                      )),
                  BlocBuilder<IsupdateCubit, IsupdateState>(
                    builder: (context, state) {
                      if (state is IsUpdateInitialState) {
                        return state.isshow
                            ? IconButton(
                                onPressed: () async {
                                  cubitisUpdate.isUpdate(false);
                                },
                                icon: Icon(
                                  Icons.check,
                                  size: 30,
                                  color: textColor,
                                ))
                            : Container();
                      }
                      return Text('error');
                    },
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
                        onTap: () => cubitisUpdate.isUpdate(true),
                        onTapOutside: (event) => cubitisUpdate.isUpdate(false),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 25,
                        ),
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '${S.of(context).hintAddNote}',
                          hintStyle: robotoRegular.copyWith(
                              fontSize: 22, color: textColor),
                          border: InputBorder.none,
                        ),
                      ),
                      TextFormField(
                        keyboardAppearance: Brightness.light,
                        onTap: () => cubitisUpdate.isUpdate(true),
                        onTapOutside: (event) {
                          cubitisUpdate.isUpdate(false);
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: bodyController,
                        style: TextStyle(
                          color: textColor,
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
                                '${DateFormat('MMM d  h:mm a').format(DateTime.now().toLocal())}',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: textColor),
                              ),
                              Text(
                                '  |  ',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: textColor),
                              ),
                              Text(
                                '$currentLength ${S.of(context).Characters}',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: textColor),
                              ),
                            ],
                          );
                        },
                        decoration: InputDecoration(
                          hintText: '${S.of(context).Starttyping}',
                          hintStyle: robotoRegular.copyWith(
                              fontSize: 17, color: textColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container(
            color: Colors.red,
          );
        },
      ),
    );
  }
}
