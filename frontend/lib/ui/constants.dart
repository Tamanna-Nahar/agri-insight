import 'package:flutter/material.dart';


class constants{

  //Primary color
  static var p1 =  const Color(0xFFfef7ed);
  static var primaryColor = const Color(0xff296e48);
  static var blackColor = Colors.black54;
  static var titleOne="Welcome to \n AGRI-INSIGHT";
  static var descriptionOne="Revolutionize Your Farming Practices with Precision Agriculture";
  static var titleTwo="Accurate Weather Predictions";
  static var descriptionTwo="Plan your farming activities with real-time weather updates and forecasts.";
  static var titleThree="Market Data Analysis";
  static var descritpionThree="Stay ahead with insightful market trends and data analysis to make informed decisions.";

}
class Constants {
  final primaryColor = const Color(0xff6b9dfc);
  final secondaryColor = const Color(0xffa1c6fd);
  final tertiaryColor = const Color(0xff205cf1);
  final blackColor = const Color(0xff1a1d26);

  final greyColor = const Color(0xffd9dadb);

  final Shader shader = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final linearGradientBlue =  const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [Color(0xff6b9dfc), Color(0xff205cf1)],
      stops: [0.0,1.0]
  );
  final linearGradientPurple =  const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [Color(0xff51087E), Color(0xff6C0BA9)],
      stops: [0.0,1.0]
  );
}