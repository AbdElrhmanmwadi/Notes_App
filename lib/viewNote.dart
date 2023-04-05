import 'package:flutter/material.dart';

class ViewNote extends StatelessWidget {
  const ViewNote({Key? key}) : super(key: key);

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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: InkWell(
            splashFactory: InkSplash.splashFactory,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                padding: EdgeInsets.all(7),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )),
          ),
          actions: [
            ButtonBar(
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
                        Icons.save_rounded,
                        color: Colors.black,
                      )),
                ),
                //
              ],
            )
          ],
        ),
      ),
    );
  }
}
