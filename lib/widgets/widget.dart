import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
      title: Text('Flutter Connect', style: TextStyle(color: Colors.white),),
  );
}
InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      )
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white54,
      )
    ),
  );
}