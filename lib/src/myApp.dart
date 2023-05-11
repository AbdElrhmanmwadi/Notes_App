import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/src/features/Note/addnote.dart';
import 'package:note/src/features/home/homeScreen.dart';

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
      home: HomeScreen(initIndex: 0,),
      routes: {
        'HomeScreen': (context) => HomeScreen(initIndex: 0,),
        'AddNote': (context) => const Addnote(),
      },
    );
  }
}
