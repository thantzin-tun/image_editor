
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_editor_app/data/text-editing-operations-icon-data.dart';

class TextEditorIconController extends GetxController {

    TextEditingOperationsIconData myTextController = TextEditingOperationsIconData();

  //Change FontSize
    void changeFontSize(double selectFontSizeValue) {
        myTextController.myFontSize.value = selectFontSizeValue;
    }

  //Change FontColor
   void changeFontColor(Color selectFontColor) {
        myTextController.myFontColor.value = selectFontColor;
    }

  //Change Alignment Text
  void changeAlignment(int alignment) {
        myTextController.myFontAlignment.value = alignment;
    }

    //Change FontBold
    void changeBold(bool myBold) {
        myTextController.myFontBold.value  = myBold;
    }

    //Change FontItalic
     void changeItalic(bool myItalic) {
        myTextController.myFontItalic.value  = myItalic;
    }

    //Change Font Family
    void changeFontFamily(int index) {
        myTextController.fontFamilyIndex.value  = index;
    }

    //Change upperCase to lower Case
    void upperLower(bool isChangeLowerUpper) {
      myTextController.upperLowerCase.value = isChangeLowerUpper;
    }


    //void textWidget drag
    void dragTextWidgetFun(offsetValue) {
      myTextController.offset.value += offsetValue;
    }

    //Degree Rotation
    void degreeRotation(double degree) {
      myTextController.rotation.value = degree;
    }

}