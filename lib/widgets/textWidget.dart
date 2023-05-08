// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MyTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;

  const MyTextWidget(
      {super.key,
      this.text = "Button",
      this.color = Colors.white,
      this.fontSize = 20,
      this.fontStyle = FontStyle.normal,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color, 
            fontSize: fontSize, 
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            ));
  }
}
