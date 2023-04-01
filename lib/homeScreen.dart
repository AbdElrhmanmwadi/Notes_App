// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white70, Colors.white],
          stops: [0.1, 0.8, 0.99],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Notes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
          actions: [
            //
            ButtonBar(
              buttonPadding: EdgeInsets.all(7),
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
                        Icons.search,
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
                        Icons.error_outline_outlined,
                        color: Colors.black,
                      )),
                ),
              ],
            )
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'images/rafiki.png',
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Create your first note !',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
