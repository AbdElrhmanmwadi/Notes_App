// ignore_for_file: unnecessary_new, prefer_const_constructors, unused_import, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:note/src/common/widget/bottomShettForDeleteOrShare.dart';
import 'package:note/src/common/widget/CircularProgresIndicator.dart';
import 'package:note/src/common/widget/DeleteBottomSheet.dart';
import 'package:note/src/features/Note/widget/SearchTextFormField.dart';

import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/features/home/homeScreen.dart';
import 'package:note/src/sql/SqlDb.dart';
import 'package:note/src/utils/styles.dart';
import 'package:note/src/features/Note/viewEditNote.dart';

import '../../Note/widget/cardNote.dart';
import '../../../controller/sqlConrtoller.dart';

class pageOne extends StatelessWidget {
  const pageOne({
    super.key,
    required this.controller,
    required this.sqlDb,
  });

  final SqlController controller;
  final SqlDb sqlDb;

  @override
  Widget build(BuildContext context) {
  
    return Container(
        
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          SearchTextFormField(
            hintText: 'Search notes',
            icon: Icons.search,
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: FutureBuilder(
              future: controller.readData('notes'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StaggeredGridView.countBuilder(
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                      padding: EdgeInsets.zero,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) =>
                          new ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  viewEditNote(
                                    title: '${snapshot.data[index]['title']}',
                                    body: '${snapshot.data[index]['note']}',
                                    id: snapshot.data[index]['id'],
                                  ),
                                );
                              },
                              onLongPress: () {
                                Get.bottomSheet(
                                    barrierColor: Colors.transparent,
                                    bottomShettForDeleteOrShare(
                                      sqlDb: sqlDb,
                                      Widgett: deleteBottomSeet(
                                        sqlDb: sqlDb,
                                        function: () async {
                                          await sqlDb.delete('notes',
                                              'id=${snapshot.data[index]['id']}');
                                          Get.back();
                                        },
                                      ),
                                    ));
                              },
                              child: CardNote(
                                  title: '${snapshot.data[index]['title']}',
                                  Body: '${snapshot.data[index]['note']}',
                                  date: '${snapshot.data[index]['date']}'),
                            ),
                          ));
                } else {
                  return CircularProgresIndicator();
                }
              },
            ),
          ),
          // Expanded(
          //   child: GetBuilder(
          //       init: SqlController(),
          //       builder: (context) => FutureBuilder(
          //             future: controller.readData('notes'),
          //             builder: (context, snapshot) {
          //               if (snapshot.hasData) {
          //                 return StaggeredGridView.countBuilder(
          //                     staggeredTileBuilder: (index) =>
          //                         StaggeredTile.fit(1),
          //                     padding: EdgeInsets.zero,
          //                     crossAxisCount: 2,
          //                     shrinkWrap: true,
          //                     itemCount: snapshot.data.length,
          //                     itemBuilder: (BuildContext context,
          //                             int index) =>
          //                         new ClipRRect(
          //                           borderRadius: BorderRadius.all(
          //                               Radius.circular(15.0)),
          //                           child: GestureDetector(
          //                             onTap: () {
          //                               Get.to(
          //                                 ViewNote(
          //                                   title:
          //                                       '${snapshot.data[index]['title']}',
          //                                   body:
          //                                       '${snapshot.data[index]['note']}',
          //                                   id: snapshot.data[index]['id'],
          //                                 ),
          //                               );
          //                             },
          //                             onLongPress: () {
          //                               Get.bottomSheet(
          //                                   barrierColor: Colors.transparent,
          //                                   bottomShettForDeleteOrShare(
          //                                     sqlDb: sqlDb,
          //                                     Widgett: deleteBottomSeet(
          //                                       sqlDb: sqlDb,
          //                                       function: () async {
          //                                         await sqlDb.delete('notes',
          //                                             'id=${snapshot.data[index]['id']}');
          //                                         Get.back();
          //                                       },
          //                                     ),
          //                                   ));
          //                             },
          //                             child: CardNote(
          //                                 title:
          //                                     '${snapshot.data[index]['title']}',
          //                                 Body:
          //                                     '${snapshot.data[index]['note']}',
          //                                 date:
          //                                     '${snapshot.data[index]['date']}'),
          //                           ),
          //                         ));
          //               } else {
          //                 return CircularProgresIndicator();
          //               }
          //             },
          //           )),
          // )
        ]));
  }
}
