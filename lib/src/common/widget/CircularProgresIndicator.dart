// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CircularProgresIndicator extends StatelessWidget {
  const CircularProgresIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.amber),
      ),
    );
  }
}
