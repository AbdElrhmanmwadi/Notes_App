// ignore_for_file: prefer_const_constructors, dead_code

import 'package:flutter/material.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAddNote = false;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white70, Colors.white],
          stops: [0.1, 0.8, 0.99],
        ),
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: .5,
          backgroundColor: Colors.black12,
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.of(context).pushNamed('AddNote');
          },
          child: Icon(Icons.add),
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Notes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
          actions: [
            //
            ButtonBar(
              buttonPadding: EdgeInsets.all(7),
              children: [
                //
                InkWell(
                  splashFactory: InkSplash.splashFactory,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                      )),
                ),
                //
                InkWell(
                  splashFactory: InkSplash.splashFactory,
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.error_outline_outlined,
                        color: Colors.black,
                      )),
                ),
              ],
            )
          ],
        ),
        body: isAddNote
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          title: Text(
                            'fontSize: 20,',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                  );
                },
              )
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        'images/rafiki.png',
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Create your first note !',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
