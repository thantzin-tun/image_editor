import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:image_editor_app/controller/drawing-shape-controller.dart';
import 'package:image_editor_app/controller/image-picker-controller.dart';
import 'package:image_editor_app/controller/text-details-controller.dart';
import 'package:image_editor_app/screens/image-editor-home-screen.dart';
import 'package:image_editor_app/screens/shapeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  TextEditorIconController myTextController = Get.put(TextEditorIconController());
  ImagePickerController imagePickerController = Get.put(ImagePickerController());
  DrawingShapeController drawingShapeController = Get.put(DrawingShapeController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Editor Photo',
        theme: ThemeData(
          tooltipTheme: const TooltipThemeData(preferBelow: false),
          brightness: Brightness.light,
          primarySwatch: Colors.lightBlue,
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
        home: ImagePickerWidget());
  }
}