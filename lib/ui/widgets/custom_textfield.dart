import 'package:flutter/material.dart';

import '../constants.dart';


class Customtextfield extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final String hintText;

  const Customtextfield({
    Key ? key, required this.controller ,required this.obscureText, required this.hintText, required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: constants.blackColor,

      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(icon,color: constants.blackColor.withOpacity(.3),),
        hintText: hintText,
      ),
      cursorColor: constants.blackColor.withOpacity(.5),
    );
  }
}
