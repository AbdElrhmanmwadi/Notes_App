// ignore_for_file: unnecessary_new, prefer_const_constructors, unused_import, camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:note/generated/l10n.dart';
import 'package:note/src/common/widget/bottomShettForDeleteOrShare.dart';
import 'package:note/src/common/widget/CircularProgresIndicator.dart';
import 'package:note/src/common/widget/DeleteBottomSheet.dart';
import 'package:note/src/features/Note/data/datasources/local/note_local_data_source.dart';
import 'package:note/src/features/Note/data/repositories/note_repository_imp.dart';
import 'package:note/src/features/Note/domain/repositories/note_repository.dart';
import 'package:note/src/features/Note/presentation/bloc/crud_bloc.dart';
import 'package:note/src/features/Note/presentation/view/widget/cardNote.dart';
import 'package:note/src/features/Note/presentation/view/widget/viewEditNote.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/features/home/homeScreen.dart';

import 'package:note/src/utils/string/massage.dart';
import 'package:note/src/utils/styles.dart';

import '../widget/SearchTextFormField.dart';

class pageOne extends StatelessWidget {
  const pageOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          SearchTextFormField(
            hintText: '${S.of(context).search}',
            icon: Icons.search,
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: BlocBuilder<CrudBloc, CrudState>(builder: (context, state) {
              if (state is LoadedNoteState) {
                final data = state.notes;
                print('loaded');
                return StaggeredGridView.countBuilder(
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) => ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => viewEditNote(
                                  title: data[index].title,
                                  body: data[index].note,
                                  id: data[index].id,
                                ),
                              ));
                            },
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                barrierColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return bottomShettForDeleteOrShare(
                                    Widgett: deleteBottomSeet(
                                      function: () async {
                                        BlocProvider.of<CrudBloc>(context).add(
                                            DeleteNoteEvent('notes',
                                                'id=${data[index].id}'));
                                        // Navigator.of(context).pop(2);

                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return HomeScreen(
                                                initIndex: 0,
                                              ); // The page you're navigating to
                                            },
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            child: Hero(
                              tag: '${data[index].id}',
                              flightShuttleBuilder: (BuildContext flightContext,
                                  Animation<double> animation,
                                  HeroFlightDirection flightDirection,
                                  BuildContext fromHeroContext,
                                  BuildContext toHeroContext) {
                                return Icon(Icons.star, color: Colors.yellow);
                              },
                              child: CardNote(
                                  color: Color(int.parse(
                                      data[index].backgroundColor)),
                                  title: data[index].title,
                                  Body: data[index].note,
                                  date: '${data[index].date}'),
                            ),
                          ),
                        ));
              } else if (state is LoadingNoteState) {
                print('loading');
                return Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ));
              }
              return Center(
                child: Text('${S.of(context).emptyNote}'),
              );
            }),
          ),
        ]));
  }
}
