// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:note/src/common/widget/iconLableSheet.dart';

class bottomShettForDeleteOrShare extends StatelessWidget {
  final Widgett;
  const bottomShettForDeleteOrShare({
    super.key,
    required this.Widgett,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                splashColor: Colors.white,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0), child: Widgett),
                      shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.transparent);

                
                },
                child: iconLableBottomSheet(
                  icon: Icons.delete_outline_outlined,
                  lable: 'Delete',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
