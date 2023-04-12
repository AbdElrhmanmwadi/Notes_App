import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/addnote.dart';
import 'package:note/homeScreen.dart';
import 'package:note/viewNote.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme:
            const InputDecorationTheme(prefixIconColor: Colors.grey),
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        'HomeScreen': (context) => const HomeScreen(),
        'AddNote': (context) => const Addnote(),
      },
    );
  }
}
