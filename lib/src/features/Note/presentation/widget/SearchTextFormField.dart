import 'package:flutter/material.dart';

class SearchTextFormField extends StatelessWidget {
  final icon, hintText;
  const SearchTextFormField({
    super.key,required this.icon,required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 0),
      hintText: hintText,
      hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: Colors.black.withOpacity(.5)),
      focusColor: Colors.red,
      prefixIcon: Icon(
       icon, 
        size: 20,
      ),
      fillColor: Colors.grey.withOpacity(.1),
      filled: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none),
    ));
  }
}