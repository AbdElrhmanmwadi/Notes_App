 // ignore_for_file: prefer_const_constructors

 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/src/controller/addNoteController.dart';

class WillPopDialog extends StatelessWidget {
const WillPopDialog({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    ViewNoteController controller= Get.put(ViewNoteController());
    return Container(
      child: AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              backgroundColor: Colors.white38,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Center(
                  child: Icon(
                Icons.error,
                color: Colors.white,
              )),
              content: Text(
                "Are your sure you want discard your changes ?",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
              ),
              actions: [
                MaterialButton(
                  color: Colors.white54,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Keep"),
                ),
                MaterialButton(
                  textColor: Colors.white,
                  color: Colors.white38,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                
                   controller.canPop.value = true;
                 
                    Navigator.of(context).pushNamed('HomeScreen');
                  },
                  child: Text("Discard"),
                ),
              ],
            ),
    );
  }
}