import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 48, 47, 47),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
