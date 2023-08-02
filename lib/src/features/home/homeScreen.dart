// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:note/src/common/widget/DeleteBottomSheet.dart';
import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';
import 'package:note/src/features/Note/data/repositories/note_repository_imp.dart';
import 'package:note/src/features/Note/presentation/bloc/note_bloc.dart';
import 'package:note/src/features/Note/presentation/widget/SearchTextFormField.dart';
import 'package:note/src/features/Note/presentation/widget/addnote.dart';
import 'package:note/src/features/Note/presentation/widget/viewEditNote.dart';

import 'package:note/src/features/Task/widget/bottomShettTask.dart';
import 'package:note/src/controller/sqlConrtoller.dart';
import 'package:note/src/features/home/widget/pageone.dart';
import 'package:note/src/features/home/widget/pagetwo.dart';
import 'package:note/src/sql/SqlDb.dart';

import '../../common/widget/CircularProgresIndicator.dart';
import '../../common/widget/bottomShettForDeleteOrShare.dart';
import '../Note/presentation/widget/cardNote.dart';

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
              // sqlDb.deleteMyDatabase();
            } else {
              Get.bottomSheet(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: bottomShettTask(
                      hint: 'Enter tap to save task',
                      taskController: taskController,
                      sqlDb: sqlDb,
                      onPressed: () async {
                        var respones = await sqlDb.insert('tasks',
                            {'task': taskController.text, 'isComplete': 1});
                        if (respones > 0) {
                          print(respones);
                        }
                        Get.back();
                      }),
                ),
              );
            }
          },
          child: Icon(
            Icons.add,
            size: 35,
          ),
        ),
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
            Container(
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
                    child: BlocBuilder<NoteBloc, NoteState>(
                        builder: (context, state) {
                      if (state is LoadedNoteState) {
                        final data = state.notes;
                        print('loaded');
                        return StaggeredGridView.countBuilder(
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.fit(1),
                            padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        viewEditNote(
                                          title: '${data[index].title}',
                                          body: '${data[index].note}',
                                          id: data[index].id,
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
                                                    'id=${data[index].id}');
                                                Get.back();
                                              },
                                            ),
                                          ));
                                    },
                                    child: CardNote(
                                        title: '${data[index].title}',
                                        Body: '${data[index].note}',
                                        date: '${data[index].date}'),
                                  ),
                                ));
                      } else if (state is LoadingNoteState) {
                        print('loading');
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.amber),
                        ));
                      }
                      return CircularProgresIndicator();
                    }),
                  ),
                ])),
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
