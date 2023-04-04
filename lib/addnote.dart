// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';

class Addnote extends StatefulWidget {
  const Addnote({Key? key}) : super(key: key);

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  @override
  Widget build(BuildContext context) {
    bool _canPop = false;
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white70, Colors.white],
          stops: [0.1, 0.8, 0.99],
        ),
      ),
      child: WillPopScope(
        onWillPop: () async {
          if (_canPop) {
            return true;
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
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
                  "Are your sure you want discard your changes ?",
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
                      Navigator.of(context).pop();
                    },
                    child: Text("Keep"),
                  ),
                  MaterialButton(
                    textColor: Colors.white,
                    color: Colors.white38,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      setState(() {
                        _canPop = true;
                      });
                      Navigator.of(context).pushNamed('HomeScreen');
                    },
                    child: Text("Discard"),
                  ),
                ],
              ),
            );
            return false;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: InkWell(
              splashFactory: InkSplash.splashFactory,
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.of(context).pop();
              },
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
                          Icons.save_rounded,
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
                          Icons.archive_rounded,
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
                      controller: titleController,
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                      ),
                      maxLines: null,
                      maxLength: 1000,
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              required maxLength}) =>
                          Text('$currentLength'),
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
                      controller: bodyController,
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      ),
                      maxLines: null,
                      maxLength: 1000,
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              required maxLength}) =>
                          Text('$currentLength'),
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
      ),
    );
  }
}
