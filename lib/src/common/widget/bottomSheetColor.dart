 import 'package:flutter/material.dart';
import 'package:note/src/common/listColor.dart';
import 'package:note/src/features/Note/presentation/cubit/background_color_cubit.dart';

Future<dynamic> bottomSheetColor(BuildContext context, BackgroundColorCubit cubitbackground) {
    return showModalBottomSheet(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext sheetContext) {
                          return Container(
                            height: 120,
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 12.0,
                                runSpacing: 12.0,
                                children: backgroundColorss.map((color) {
                                  return GestureDetector(
                                    onTap: () {
                                      cubitbackground
                                          .changeBackgroundColor(color);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      width: 100,
                                      height: 100,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      );
  }
