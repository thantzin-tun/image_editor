// ignore: file_names

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import "package:get/get.dart";
import 'package:google_fonts/google_fonts.dart';

class TextEditingOperationsIconData {
    RxDouble myFontSize = RxDouble(12.0); 
    Rx<Color> myFontColor = Rx<Color>(Colors.white);
    Rx<int> myFontAlignment = RxInt(1);
    Rx<bool> myFontBold = RxBool(false);
    Rx<bool> myFontItalic = RxBool(false);
    Rx<int> fontFamilyIndex = RxInt(0);
    Rx<bool> upperLowerCase = RxBool(false);

    //text-rotation with degree
    Rx<double> rotation = 0.0.obs;

    //Offset Value for textWidget Drag
    Rx<Offset> offset = Offset.zero.obs;
}

