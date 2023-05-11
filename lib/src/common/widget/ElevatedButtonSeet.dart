// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ElevatedButtonSeet extends StatelessWidget {
  final Color backgeroundColor;
  final Color forgroundColor;
  final String lablel;
  final Function()? function;

  const ElevatedButtonSeet({
    super.key, required this.backgeroundColor, required this.forgroundColor, required this.lablel, this.function,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: forgroundColor,
            backgroundColor: backgeroundColor,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        onPressed: function,
        child: Text(lablel));
  }
}
