import 'dart:ui';
import "dart:math" as math;
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:image_editor_app/controller/drawing-shape-controller.dart';
import 'package:image_editor_app/controller/image-picker-controller.dart';
import "package:get/get.dart";
import 'package:image_editor_app/controller/text-details-controller.dart';
import 'package:image_editor_app/utils/editingTextThemeData/fonts.dart';

import '../utils/constants.dart';
import '../widgets/textWidget.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  //this controller is handling for gallery pick,camera shot,crop image,saveImage,drawerImage
  ImagePickerController controller = Get.find<ImagePickerController>();

  //Handling TextWidget For fontChange,colorChange,textTransformChange,bold,italic
  TextEditorIconController textEditorIconController =
      Get.find<TextEditorIconController>();

  //Drawing Shape Controller
  DrawingShapeController drawingShapeController =
      Get.find<DrawingShapeController>();

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
            onInteractionEnd: (details) {
              debugPrint("User action end");
            },
            onInteractionStart: (details) {
              debugPrint("User action start");
            },
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RepaintBoundary(
                  key: controller.globalKey,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(controller.imageFile.value),
                      // ignore: unrelated_type_equality_checks

                      //For Painter
                      if (controller.isPaint.value)
                        GestureDetector(
                            onPanDown: (details) {
                              final renderBox =
                                  context.findRenderObject() as RenderBox;
                              final localPosition = renderBox
                                  .globalToLocal(details.globalPosition);
                              controller.userTapPositionOffset(localPosition);
                            },
                            onPanUpdate: (details) {
                              final renderBox =
                                  context.findRenderObject() as RenderBox;
                              final localPosition = renderBox
                                  .globalToLocal(details.globalPosition);

                              controller.userTapPositionOffset(localPosition);
                            },
                            child: CustomPaint(
                              // ignore: invalid_use_of_protected_member
                              painter: PaintDrawing(controller.offsets.value,
                                  controller.initialColor.value),
                              child: Container(
                                width: double.infinity,
                                color: myTransparent,
                              ),
                            )),

                      //For Text
                      Obx(
                        () => Positioned(
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
                                  ? "save humans,save cat".toLowerCase()
                                  : "save humans,save cat".toUpperCase(),
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
                              textAlign: textEditorIconController
                                          .myTextController
                                          .myFontAlignment
                                          .value ==
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
                      ),
                    ],
                  ),
                )),
          ));
  }
}

class PaintDrawing extends CustomPainter {
  // ignore: prefer_typing_uninitialized_variables
  final offsets; //Take x-coordinate and y-coordinate offset(300,200);

  Color initialColor; //For initial Color

  PaintDrawing(this.offsets, this.initialColor);

  @override
  void paint(Canvas canvas, Size size) {
    // Canvas canvas = Canvas(record);
    // canvas.scale(pixelRatio, pixelRatio);
    // Paint က သူထဲမှာ .. နဲ့ တွေ ခဲတံ အကျယ်တွေ အရောင်တွေထည့်လိူ့ရတယ္
    final paint = Paint()
      ..color = initialColor
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round;

    // final a = offsets(size.width * 1/6 , size.height * 1/4);
    // final b = offsets(size.width * 3/4 , size.height * 3/4);

    // final rect = Rect.fromPoints(a, b);
    for (var i = 0; i < offsets.length; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(offsets[i], offsets[i + 1], paint);
      } else if (offsets[i] != null && offsets[i + 1] == null) {
        // canvas.drawPoints(PointMode.points, [offsets[i]], paint);
        return;
      }
      // canvas.drawCircle(offsets[i], 7, paint);
    }

    // canvas.drawRect(rect, paint);
    // canvas.drawLine(offsets(size.width,size.height),offsets(size.width ,size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
