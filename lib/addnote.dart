// ignore_for_file: prefer_const_constructors, unused_local_variable, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/dimensions.dart';
import 'package:note/styles.dart';

var sumLength = 0;

class Addnote extends StatefulWidget {
  const Addnote({Key? key}) : super(key: key);

  @override
  State<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  @override
  Widget build(BuildContext context) {
    var LengthOne = 0;
    var LengthTwo = 0;
    setState(() {
      sumLength;
    });
    bool _canPop = false;
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();
    return WillPopScope(
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
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.color_lens_rounded,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.black,
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                  maxLines: null,
                  maxLength: 1000,
                  buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) {
                    LengthOne = currentLength;
                    sumLength = LengthOne + LengthTwo;
                    return Row(
                      children: [
                        Text(
                          '${DateFormat('M-dd-h:mm').format(DateTime.now())}',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.black38),
                        ),
                        Text(
                          '  |  ',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.black26),
                        ),
                        Text(
                          '$sumLength Characters',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.black38),
                        ),
                      ],
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: robotoRegular.copyWith(
                        fontSize: 22, color: Colors.black45),
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  controller: bodyController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  maxLines: null,
                  maxLength: 1000,
                  buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      required maxLength}) {
                    LengthTwo = currentLength;

                    return Container();
                  },
                  decoration: InputDecoration(
                    hintText: 'Start typing',
                    hintStyle: robotoRegular.copyWith(
                        fontSize: 17, color: Colors.black45),
                    border: InputBorder.none,
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
