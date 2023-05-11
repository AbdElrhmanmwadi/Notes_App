import 'package:flutter/material.dart';
import 'package:note/src/utils/dimensions.dart';
import 'package:note/src/utils/styles.dart';

class iconLableBottomSheet extends StatelessWidget {
  final icon, lable;
  const iconLableBottomSheet({
    super.key,
    required this.icon,
    required this.lable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        Text(
          lable,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
        )
      ],
    );
  }
}
