import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawingShapeController extends GetxController {
  
  RxList<DrawingPoint?> drawPoints = RxList<DrawingPoint?>([]);

  var initialColor = Rx<Color>(Colors.white);
  var isPaint = Rx<bool>(false);

  //Drawing Sketch Color Change
  void changeSketchColor(chooseColor) {
    initialColor.value = chooseColor;
  }

  //Drawing isPaint Change
  void isPaintChange(isPaintStatus) {
    isPaint.value = isPaintStatus;
  }

  //During user sketch and update 
  void setDrawingPoint(Offset offset, Paint paint) {
    DrawingPoint drawingPoint = DrawingPoint(offset, paint);
    drawPoints.add(drawingPoint);
    }

    void resetDrawPoints() {
        drawPoints.add(null);
    }
}

class DrawingPoint {
  Offset offset;
  Paint paint;
  DrawingPoint(this.offset, this.paint);
}
