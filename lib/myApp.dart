import 'package:flutter/material.dart';
import 'package:note/addnote.dart';
import 'package:note/homeScreen.dart';
import 'package:note/viewNote.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const homeScreen(),
      routes: {
        'HomeScreen': (context) => homeScreen(),
        'AddNote': (context) => Addnote(),
        'ViewNote':(context) => ViewNote(),
      },
    );
  }
}
