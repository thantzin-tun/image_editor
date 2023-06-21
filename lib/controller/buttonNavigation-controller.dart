import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonNavigationController extends GetxController {
    var selectedIndex = Rx<int>(-1); //Whole Buttom Navigation Blue Color Animation

    void changeSelectIndex(int indexNumber) {
        selectedIndex.value = indexNumber;
    }
}