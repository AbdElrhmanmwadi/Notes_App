import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/src/common/fuction/function..dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/utils/styles.dart';

class CardNote extends StatelessWidget {
  final title, Body, date, color;
  const CardNote({
    super.key,
    required this.title,
    required this.Body,
    required this.date,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color ForegroundColor = getForegroundColor(color);
    return Card(
      borderOnForeground: false,
      color: color,
      elevation: .9,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: ForegroundColor)),
            const SizedBox(
              height: 15,
            ),
            Text(
              Body,
              style: robotoRegular.copyWith(
                  fontWeight: FontWeight.w200, color: ForegroundColor),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '${DateFormat.MMMEd().format(date)}',
              style: robotoRegular.copyWith(
                  fontWeight: FontWeight.w100, color: ForegroundColor),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
