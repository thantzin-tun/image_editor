import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_editor_app/utils/constants.dart';
import 'package:image_editor_app/widgets/textWidget.dart';

class MyAlertDialogBox extends StatefulWidget {
  final String titleText;
  final String contentText;
  final Color primaryButtonColor;
  final String primaryButtonText;
  final String secondaryButtonText;
  final Function primaryFunction;
  final Function secondaryFunction;

  MyAlertDialogBox({
    required this.titleText,
    required this.contentText,
    required this.primaryButtonColor,
    required this.primaryButtonText,
    required this.primaryFunction,
    required this.secondaryButtonText,
    required this.secondaryFunction,
  });

  @override
  State<MyAlertDialogBox> createState() => _MyAlertDialogBoxState();
}

class _MyAlertDialogBoxState extends State<MyAlertDialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: MyTextWidget(
        text: widget.titleText,
        fontWeight: FontWeight.bold,
        color: defaultBlackColor,
      ),
      content: MyTextWidget(
        text: widget.contentText,
        color: Colors.black,
        fontSize: 15,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              widget.secondaryFunction();
            },
            child: MyTextWidget(
              text: widget.secondaryButtonText,
              color: Colors.black,
              fontSize: 15,
            )),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryButtonColor),
          child: MyTextWidget(
            text: widget.primaryButtonText,
            fontSize: 15,
            color: defaultWhiteColor,
          ),
          onPressed: () {
            widget.primaryFunction();
          },
        ),
      ],
    );
  }
}
