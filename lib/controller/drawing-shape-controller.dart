import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_editor_app/data/drawing-shape-operations-data.dart';

class DrawingShapeController extends GetxController {

    DrawingShapeOperationsData drawingShape = DrawingShapeOperationsData(); 

    void drawShapeCircle() {
        drawingShape.isStar.value = true;
    }

}