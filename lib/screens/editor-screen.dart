// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:math" as math;
import 'dart:developer';
import 'dart:ui';

import "package:get/get.dart";
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:image_editor_app/controller/drawing-shape-controller.dart';
import 'package:image_editor_app/controller/image-picker-controller.dart';
import 'package:image_editor_app/controller/text-details-controller.dart';
import 'package:image_editor_app/utils/editingTextThemeData/fonts.dart';

import '../utils/constants.dart';
import '../widgets/textWidget.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen();

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  //this controller is handling for gallery pick,camera shot,crop image,saveImage,drawerImage
  ImagePickerController controller = Get.find();
  //Handling TextWidget For fontChange,colorChange,textTransformChange,bold,italic
  TextEditorIconController textEditorIconController = Get.find();
  //Drawing Shape Controller
  DrawingShapeController drawingShapeController = Get.find();

  List<DrawingPoint?> drawingPoints = [];

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.imageFile.value == null ||
            controller.imageFile.value.path.isEmpty
        ? Container(
            width: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  MyTextWidget(
                    text: "Add your photo",
                    fontSize: 40,
                    color: defaultWhiteColor,
                  ),
                  Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: defaultWhiteColor,
                  )
                ],
              ),
            ),
          )
        : InteractiveViewer(
            panEnabled: true,
            scaleEnabled: true,
            minScale: 0.1,
            maxScale: 5,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: RepaintBoundary(
                  key: controller.globalKey,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(controller.imageFile.value),
                      // ignore: unrelated_type_equality_checks
                      //For Painter
                      if (drawingShapeController.isPaint.value)
                        Stack(
                          children: <Widget>[
                            // allSketch(context),
                            currentSketch(context),
                          ],
                        ),
                      //For Text
                      Positioned(
                        left: textEditorIconController
                            .myTextController.offset.value.dx,
                        top: textEditorIconController
                            .myTextController.offset.value.dy,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            textEditorIconController
                                .dragTextWidgetFun(details.delta);
                          },
                          child: Text(
                            // ignore: unrelated_type_equality_checks
                            textEditorIconController
                                        .myTextController.upperLowerCase ==
                                    true
                                ? "Giordano".toLowerCase()
                                : "Giordano",
                            style: TextStyle(
                                fontFamily: fonts[textEditorIconController
                                        .myTextController.fontFamilyIndex
                                        .toInt()]
                                    .fontFamily,
                                fontWeight: textEditorIconController
                                        .myTextController.myFontBold.value
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontStyle: textEditorIconController
                                        .myTextController.myFontItalic.value
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                fontSize: textEditorIconController
                                    .myTextController.myFontSize.value,
                                color: textEditorIconController
                                    .myTextController.myFontColor.value),
                            textAlign: textEditorIconController.myTextController
                                        .myFontAlignment.value ==
                                    0
                                ? TextAlign.left
                                : textEditorIconController.myTextController
                                            .myFontAlignment.value ==
                                        1
                                    ? TextAlign.center
                                    : TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ));
  }

  Widget currentSketch(BuildContext context) {
    return GestureDetector(
        onPanDown: (details) {
          drawingShapeController.setDrawingPoint(
              details.localPosition,
              Paint()
                ..color = drawingShapeController.initialColor.value
                ..isAntiAlias = true
                ..strokeWidth = 5.0
                ..strokeCap = StrokeCap.round);
        },
        onPanUpdate: (details) {
          drawingShapeController.setDrawingPoint(
              details.localPosition,
              Paint()
                ..color = drawingShapeController.initialColor.value
                ..isAntiAlias = true
                ..strokeWidth = 5.0
                ..strokeCap = StrokeCap.round);
        },
        onPanEnd: (details) {
          drawingShapeController.resetDrawPoints();
        },
        child: LayoutBuilder(
            builder: (_, constraints) => Container(
                width: constraints.widthConstraints().maxWidth,
                height: constraints.heightConstraints().maxHeight,
                child: Obx(() => CustomPaint(
                      painter: _DrawingPainter(
                          drawingShapeController.drawPoints.value),
                    )))));
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i]!.offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
