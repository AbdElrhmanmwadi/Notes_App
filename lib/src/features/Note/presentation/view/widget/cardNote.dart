import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/utils/styles.dart';

class CardNote extends StatelessWidget {
  final title,
      Body,
      //  date,
      color;
  const CardNote({
    super.key,
    required this.title,
    required this.Body,
    // required this.date,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      color: color,
      elevation: .9,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(.1),
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
              '${DateFormat('MMM d  h:mm a').format(DateTime.now())}',
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
