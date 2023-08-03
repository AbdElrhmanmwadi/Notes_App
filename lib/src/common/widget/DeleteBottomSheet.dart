import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/src/features/home/homeScreen.dart';
import 'package:note/src/sql/SqlDb.dart';
import 'package:note/src/utils/styles.dart';

import 'ElevatedButtonSeet.dart';

class deleteBottomSeet extends StatelessWidget {
  final function;
  const deleteBottomSeet({
    super.key,
    required this.sqlDb,
    required this.function,
  });

  final SqlDb sqlDb;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Delete note',
            style: robotoMedium.copyWith(fontSize: 17),
          ),
          Text(
            'Delete 1 item?',
            style: robotoRegular.copyWith(fontSize: 17),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: ElevatedButtonSeet(
                  forgroundColor: Colors.black,
                  backgeroundColor: Colors.grey.withOpacity(.5),
                  function: () {
                    Navigator.pop(context, 0);
                  },
                  lablel: 'Cancle',
                ),
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: ElevatedButtonSeet(
                  forgroundColor: Colors.white,
                  backgeroundColor: Colors.blue,
                  function: function,
                  lablel: 'Delete',
                ),
              ),
              SizedBox(
                width: 25,
              ),
            ],
          )
        ],
      ),
    );
  }
}
