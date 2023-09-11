// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names, unnecessary_string_interpolations, avoid_print, unused_import, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:note/generated/l10n.dart';
import 'package:note/src/common/fuction/function..dart';
import 'package:note/src/common/listColor.dart';
import 'package:note/src/common/widget/bottomSheetColor.dart';

import 'package:note/src/features/Note/presentation/bloc/crud_bloc.dart';
import 'package:note/src/features/Note/presentation/cubit/background_color_cubit.dart';
import 'package:note/src/features/Note/presentation/cubit/fontsize_cubit.dart';
import 'package:note/src/features/Note/presentation/cubit/isupdate_cubit.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/features/home/homeScreen.dart';

import 'package:note/src/utils/styles.dart';

class viewEditNote extends StatelessWidget {
  final String title, body;
  final id;
  final background;

  viewEditNote({
    Key? key,
    required this.title,
    required this.body,
    required this.id,
    this.background,
  }) : super(key: key);

  TextEditingController titleController = TextEditingController();

  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    BackgroundColorCubit cubitbackground =
        BlocProvider.of<BackgroundColorCubit>(context);
    IsupdateCubit cubitisUpdate = BlocProvider.of<IsupdateCubit>(context);

    titleController.text = title;
    bodyController.text = body;

    Color backgroundColors;
    bool backroundColor = true;

    return Hero(
      tag: '$id',
      child: BlocBuilder<BackgroundColorCubit, BackgroundColorState>(
        builder: (context, state) {
          if (state is BackgroundColorInitial) {
            Color textColor = getForegroundColor(
                backroundColor ? Color(int.parse(background)) : state.color);

            print(state.color.value);
            return Scaffold(
              backgroundColor:
                  backroundColor ? Color(int.parse(background)) : state.color,
              appBar: AppBar(
                elevation: 0,
                backgroundColor:
                    backroundColor ? Color(int.parse(background)) : state.color,
                leading: BackButton(
                  color: textColor,
                  onPressed: () async {
                    BlocProvider.of<CrudBloc>(context).add(UpdateNoteEvent(
                      'notes',
                      'id=$id',
                      {
                        'note': "${bodyController.text}",
                        'title': "${titleController.text}",
                        // 'date': "${DateFormat.MMMEd().format(DateTime.now())}",
                        "backgroundColor": backroundColor
                            ? "$background"
                            : "${state.color.value}"
                      },
                    ));

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
                      return Text('');
                    },
                  )
                ],
              ),
              body: BlocBuilder<FontsizeCubit, FontsizeState>(
                builder: (context, state) {
                  if (state is changeFontSizeState) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              enabled: false,
                              controller: titleController,
                              onTap: () => cubitisUpdate.isUpdate(true),
                              onTapOutside: (event) =>
                                  cubitisUpdate.isUpdate(false),
                              style: TextStyle(
                                color: textColor,
                                fontSize: state.fontSize,
                              ),
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: '${S.of(context).hintAddNote}',
                                hintStyle: robotoRegular.copyWith(
                                    fontSize: state.fontSize, color: textColor),
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
                                fontSize: state.fontSize,
                              ),
                              maxLines: null,
                              maxLength: 1000,
                              buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  required maxLength}) {
                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '${DateFormat('MMM d  h:mm a').format(DateTime.now())}',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: textColor),
                                    ),
                                    Text(
                                      '  |  ',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: textColor),
                                    ),
                                    Text(
                                      '$currentLength ${S.of(context).Characters}',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: textColor),
                                    ),
                                  ],
                                );
                              },
                              decoration: InputDecoration(
                                hintText: '${S.of(context).Starttyping}',
                                hintStyle: robotoRegular.copyWith(
                                    fontSize: state.fontSize, color: textColor),
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('data'),
                    );
                  }
                },
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
