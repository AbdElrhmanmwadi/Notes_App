// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:note/CircularProgresIndicator.dart';
import 'package:note/DeleteBottomSheet.dart';
import 'package:note/SearchTextFormField.dart';
import 'package:note/bottomShettForDeleteOrShare.dart';
import 'package:note/dimensions.dart';
import 'package:note/homeScreen.dart';
import 'package:note/sql/SqlDb.dart';
import 'package:note/styles.dart';
import 'package:note/viewNote.dart';

import 'cardNote.dart';
import 'controller/sqlConrtoller.dart';

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
    ThemeData themeData = Theme.of(context);
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
            child: GetBuilder(
              init: SqlController(),
              builder: (context) => FutureBuilder(
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
                                    ViewNote(
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
