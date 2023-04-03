// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Addnote extends StatelessWidget {
  const Addnote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: InkWell(
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
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )),
          ),
          actions: [
            //
            ButtonBar(
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                      border: InputBorder.none,
                    ),
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
