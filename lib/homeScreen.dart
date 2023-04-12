// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note/addnote.dart';
import 'package:note/dimensions.dart';
import 'package:note/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.amberAccent,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Addnote(),
            ));
          },
          child: Icon(
            Icons.add,
            size: 35,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        endDrawer: Drawer(
          width: double.infinity,
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.yellow,
            indicatorColor: Colors.transparent,
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
          physics: BouncingScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    TextFormField(
                        decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      hintText: 'Search notes',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Colors.black.withOpacity(.5)),
                      focusColor: Colors.red,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                      ),
                      fillColor: Colors.grey.withOpacity(.1),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none),
                    )),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                        child: StaggeredGridView.countBuilder(
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.fit(1),
                            padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) =>
                                new ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  child: Card(
                                    borderOnForeground: false,
                                    color: Colors.white,
                                    elevation: .9,
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white.withOpacity(1),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Title',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeLarge)),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'body',
                                            style: robotoRegular.copyWith(
                                                fontWeight: FontWeight.w200),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            '${DateTime.now()}',
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))),
                  ],
                )),
            Text('1'),
          ],
        ),
      ),
    );
  }
}
