
import 'package:flutter/material.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/utils/styles.dart';

class CardNote extends StatelessWidget {
  final title, Body,date;
  const CardNote({
    super.key,required this.title,required this.Body,required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      color: Colors.white,
      elevation: .9,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
            SizedBox(
              height: 15,
            ),
            Text(
              Body,
              style: robotoRegular.copyWith(fontWeight: FontWeight.w200),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              date,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
