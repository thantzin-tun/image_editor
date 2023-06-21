// import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_editor_app/controller/buttonNavigation-controller.dart';
import 'package:image_editor_app/controller/drawing-shape-controller.dart';
import 'package:image_editor_app/controller/image-picker-controller.dart';
import 'package:image_editor_app/controller/text-details-controller.dart';
import 'package:image_editor_app/screens/editor-screen.dart';
import 'package:image_editor_app/utils/constants.dart';
import 'package:image_editor_app/utils/editingTextThemeData/colors.dart';
import 'package:image_editor_app/utils/editingTextThemeData/fonts.dart';
import 'package:image_editor_app/widgets/myAlertDialog.dart';
import 'package:image_editor_app/widgets/textWidget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  //Image Pick,image,crop,draw image,isPaint,isDrawing
  ImagePickerController imagePickerController = Get.find();

  //Change color,font,fontFamily
  TextEditorIconController textEditorIconController = Get.find();

  //Drawing color,isPaint
  DrawingShapeController drawingShapeController = Get.find();

  int fontIndex = -1; //fontSelect Circle Animation Index
  int colorIndex = -1; //fontColor Circle Animation Index

  bool isEditText = false; //isEditText variable is handel text_editor screen
  bool isDrawingLine = false; // Drawing stroke unable or disable

  double pixelRatio = 0.0;

  

  List<IconData> shapeIconList = [
    Icons.circle_outlined,
    Icons.square_outlined,
    Icons.rectangle_outlined,
    Icons.polymer_outlined
  ];

  List<String> type = ["circle", "square", "rectangle", "line"];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //Device Width
    pixelRatio = MediaQuery.of(context).devicePixelRatio; // Device Pixel Ratio
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.print),
            tooltip: "Print",
          ),
          title: const MyTextWidget(
            text: "Editor",
            color: appBarTextColor,
            fontStyle: FontStyle.italic,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Map<Permission, PermissionStatus> statuses = await [
                //   Permission.camera,
                //   Permission.storage,
                // ].request();
                // if (statuses[Permission.storage]!.isGranted &&
                //     statuses[Permission.camera]!.isGranted) {
                //   _takePhoto();
                // } else {
                //   print("Not permission access!");
                // }
                // _takePhoto();
                imagePickerController.getImageFromCamera();
              },
              icon: const Icon(Icons.camera_alt_rounded,
                  color: iconGradientColor),
              tooltip: "Shot Camera",
            ),
            IconButton(
              onPressed: () {
                // _getImageFromGallery();
                imagePickerController.getImageFromGallery();
              },
              icon: const Icon(Icons.file_copy, color: appBarTextColor),
              tooltip: "Upload from Gallery",
            )
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  transform: isEditText == false
                      ? Matrix4.translationValues(0, -150, 0)
                      : Matrix4.translationValues(0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Expanded(
                        
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              tooltip: "Insert Text",
                              onPressed: () {},
                              icon: const Icon(
                                Icons.title,
                                size: 20,
                                color: defaultWhiteColor,
                              ),
                            ),
                            IconButton(
                              tooltip: "Text Case",
                              onPressed: () {
                                textEditorIconController.upperLower(
                                    !textEditorIconController
                                        .myTextController.upperLowerCase.value);
                              },
                              icon: const Icon(
                                Icons.text_fields,
                                size: 20,
                                color: defaultWhiteColor,
                              ),
                            ),
                            IconButton(
                              tooltip: "Bold",
                              onPressed: () {
                                textEditorIconController.changeBold(
                                    !textEditorIconController
                                        .myTextController.myFontBold.value);
                              },
                              icon: const Icon(
                                Icons.format_bold,
                                size: 20,
                                color: defaultWhiteColor,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: defaultWhiteColor,
                              child: IconButton(
                                tooltip: "Italic",
                                onPressed: () {
                                  textEditorIconController.changeItalic(
                                      !textEditorIconController
                                          .myTextController.myFontItalic.value);
                                },
                                icon: const Icon(
                                  Icons.format_italic,
                                  size: 20,
                                  color: defaultBlackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Slider(
                            value: textEditorIconController
                                .myTextController.myFontSize.value,
                            min: 0,
                            max: 100,
                            label: "Adjust FontSize",
                            thumbColor: defaultWhiteColor,
                            activeColor: defaultWhiteColor,
                            onChanged: (double value) {
                              textEditorIconController.changeFontSize(value);
                            },
                          )
                          ),
                    ],
                  ),
                ),

                Expanded(child: EditorScreen()),
                //Select Color and Font Picker Container

                //Drawing Options
                AnimatedContainer(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width - 20.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  decoration: BoxDecoration(
                      color: defaultWhiteColor,
                      borderRadius: BorderRadius.circular(30)),
                  transform: isDrawingLine == false
                      ? Matrix4.translationValues(0, 250, 0)
                      : Matrix4.translationValues(0, 100, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                            color: defaultBlackColor,
                            borderRadius: BorderRadius.circular(40)),
                        child: IconButton(
                          tooltip: "Undo",
                          onPressed: () {
                            // imagePickerController.offset.removeLast();
                          },
                          icon: const Icon(
                            Icons.undo_outlined,
                            color: defaultWhiteColor,
                          ),
                        ),
                      ),
                      for (var i = 0; i < shapeIconList.length; i++)
                        IconButton(
                          iconSize: 20,
                          splashColor: Colors.transparent,
                          onPressed: () {},
                          icon: Icon(
                            shapeIconList[i],
                            color: iconGradientColor,
                          ),
                        ),
                      IconButton(
                        tooltip: "Eraser",
                        onPressed: () {
                          // imagePickerController.offsets.value =  <Offset>[];
                          //  imagePickerController.offset.value =<Offset>[];
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: defaultBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),

                //Edit text is true appear fontFamily and fontColor container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  transform: isEditText == false
                      ? Matrix4.translationValues(0, 180, 0)
                      : Matrix4.translationValues(0, 0, 0),
                  child: Column(
                    children: <Widget>[
                      
                      ///Color
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: fonts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final selectedFont = fonts[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  fontIndex = index;
                                });
                                textEditorIconController
                                    .changeFontFamily(index);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: fontIndex == index
                                        ? defaultWhiteColor
                                        : Colors.white30,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text("Aa",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: selectedFont.fontFamily,
                                          color: fontIndex == index
                                              ? defaultBlackColor
                                              : defaultWhiteColor)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      //Font
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: colors.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  colorIndex = index;
                                });
                                textEditorIconController
                                    .changeFontColor(colors[index]);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: colors[index],
                                    shape: BoxShape.circle,
                                    border: colorIndex == index
                                        ? Border.all(
                                            width: 4, color: defaultWhiteColor)
                                        : null),
                              ),
                            );
                          },
                        ),
                      ),


                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
                /////////////
              ],
            )),

        // Padding(
        //   padding: const EdgeInsets.all(5),
        //   child: Column(
        //     children: [
        //       Expanded(
        //           // ignore: unnecessary_null_comparison
        //           child: Obx(() {
        //         return imagePickerController.imageFile.value == null ||
        //                 imagePickerController.imageFile.value.path.isEmpty
        //             ? Container(
        //                 decoration: BoxDecoration(
        //                   border: Border.all(
        //                       width: 1.0,
        //                       style: BorderStyle.solid,
        //                       color: Colors.black),
        //                   color: Colors.white54,
        //                 ),
        //                 child: Center(
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: const <Widget>[
        //                       MyTextWidget(
        //                         text: "Add your photo",
        //                         fontSize: 40,
        //                         color: Colors.blueAccent,
        //                       ),
        //                       Icon(
        //                         Icons.add_a_photo,
        //                         size: 50,
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               )
        //             : InteractiveViewer(
        //                 panEnabled: true,
        //                 scaleEnabled: true,
        //                 minScale: 0.1,
        //                 maxScale: 5,
        //                 clipBehavior: Clip.hardEdge,
        //                 onInteractionEnd: (details) {
        //                   debugPrint("User action end");
        //                 },
        //                 onInteractionStart: (details) {
        //                   debugPrint("User action start");
        //                 },
        //                 child: SizedBox(
        //                     width: MediaQuery.of(context).size.width,
        //                     child: RepaintBoundary(
        //                       key: imagePickerController.globalKey,
        //                       child: Stack(
        //                         fit: StackFit.expand,
        //                         children: [
        //                           Image.file(
        //                               imagePickerController.imageFile.value),
        //                           if (isPaint)
        //                             GestureDetector(
        //                                 onPanDown: (details) {
        //                                   final renderBox = context
        //                                       .findRenderObject() as RenderBox;
        //                                   final localPosition =
        //                                       renderBox.globalToLocal(
        //                                           details.globalPosition);
        //                                   setState(() {
        //                                     _offsets.add(details.localPosition);
        //                                   });
        //                                 },
        //                                 onPanUpdate: (details) {
        //                                   final renderBox = context
        //                                       .findRenderObject() as RenderBox;
        //                                   final localPosition =
        //                                       renderBox.globalToLocal(
        //                                           details.globalPosition);
        //                                   setState(() {
        //                                     _offsets.add(details.localPosition);
        //                                   });
        //                                 },
        //                                 child: CustomPaint(
        //                                   painter: PaintDrawing(
        //                                       _offsets, initialColor),
        //                                   child: Container(
        //                                     width: double.infinity,
        //                                     color: myTransparent,
        //                                   ),
        //                                 ))
        //                         ],
        //                       ),
        //                     )),
        //               );
        //       }))
        //     ],
        //   ),
        // ),

        bottomNavigationBar: GetBuilder<ButtonNavigationController>(
          init: ButtonNavigationController(),
          builder: (controller) {
            return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    width: screenWidth * .155,
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: defaultWhiteColor),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //First
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedIndex.value == 0
                                  ? Colors.blueAccent
                                  : Colors.white,
                            ),
                            child: IconButton(
                                splashColor: Colors.white,
                                tooltip: 'Crop',
                                onPressed: () {
                                  if (imagePickerController
                                      .imageFile.value.path.isNotEmpty) {
                                    controller.changeSelectIndex(0);
                                    imagePickerController.cropImage();
                                  }
                                },
                                icon: Icon(Icons.crop,
                                    size: controller.selectedIndex.value == 0
                                        ? 28
                                        : 20,
                                    color: controller.selectedIndex.value == 0
                                        ? Colors.white
                                        : Colors.black))),
                        //End First

                        //Second Start
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedIndex.value == 1
                                  ? Colors.blueAccent
                                  : Colors.white,
                            ),
                            child: IconButton(
                                tooltip: "Text",
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  if (imagePickerController
                                      .imageFile.value.path.isNotEmpty) {
                                    controller.changeSelectIndex(1);
                                    setState(() {
                                      isEditText = true;
                                      isDrawingLine = false;
                                    });
                                  }
                                },
                                icon: Icon(Icons.text_fields,
                                    size: controller.selectedIndex.value == 1
                                        ? 28
                                        : 20,
                                    color: controller.selectedIndex.value == 1
                                        ? Colors.white
                                        : Colors.black))),

                        //Second End

                        //Third Start
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedIndex.value == 2
                                  ? Colors.blueAccent
                                  : Colors.white,
                            ),
                            child: IconButton(
                                tooltip: "Image",
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  if (imagePickerController
                                      .imageFile.value.path.isNotEmpty) {
                                    controller.changeSelectIndex(2);
                                    drawingShapeController.isPaintChange(true);
                                    setState(() {
                                      isEditText = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: <Widget>[
                                              const MyTextWidget(
                                                  text: "Pick Color",
                                                  color: defaultBlackColor),
                                              const SizedBox(width: 10),
                                              ShaderMask(
                                                blendMode: BlendMode.srcIn,
                                                shaderCallback: (Rect bounds) {
                                                  return const LinearGradient(
                                                    colors: [
                                                      iconGradientColor, // Light blue
                                                      Color.fromARGB(255, 52,
                                                          27, 213), // Blue
                                                      Color.fromARGB(255, 0, 0,
                                                          0), // Royal blue
                                                    ],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    tileMode: TileMode.mirror,
                                                  ).createShader(bounds);
                                                },
                                                child: const Icon(
                                                  Icons.palette,
                                                  size: 30,
                                                ),
                                              )
                                            ],
                                          ),
                                          content: SingleChildScrollView(
                                            child: Obx(
                                              () => ColorPicker(
                                                pickerColor:
                                                    drawingShapeController
                                                        .initialColor.value,
                                                enableAlpha: false,
                                                pickerAreaHeightPercent: 0.8,
                                                onColorChanged: (color) {
                                                  drawingShapeController
                                                      .changeSketchColor(color);
                                                },
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                  setState(() {
                                                    isDrawingLine = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        iconGradientColor),
                                                child: const MyTextWidget(
                                                  text: "Pick",
                                                  color: defaultWhiteColor,
                                                  fontSize: 15,
                                                )),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                icon: Icon(Icons.draw_rounded,
                                    size: controller.selectedIndex.value == 2
                                        ? 28
                                        : 20,
                                    color: controller.selectedIndex.value == 2
                                        ? Colors.white
                                        : Colors.black))),

                        //Third End

                        //Fourth Start
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedIndex.value == 3
                                  ? Colors.blueAccent
                                  : Colors.white,
                            ),
                            child: IconButton(
                                tooltip: "Image",
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  if (imagePickerController
                                      .imageFile.value.path.isNotEmpty) {
                                    controller.changeSelectIndex(3);
                                  }
                                },
                                icon: Icon(Icons.filter_2_outlined,
                                    size: controller.selectedIndex.value == 3
                                        ? 28
                                        : 20,
                                    color: controller.selectedIndex.value == 3
                                        ? Colors.white
                                        : Colors.black))),

                        //Fourth End

                        //Fifth Start
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedIndex.value == 4
                                  ? Colors.blueAccent
                                  : Colors.white,
                            ),
                            child: IconButton(
                                tooltip: "Save to Gallery",
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  if (imagePickerController
                                      .imageFile.value.path.isNotEmpty) {
                                    controller.changeSelectIndex(4);

                                    showDialog<void>(
                                      context: context,
                                      builder: (context) {
                                        return MyAlertDialogBox(
                                          titleText: 'Save Options',
                                          contentText:
                                              "Complete Save or Temporily",
                                          primaryButtonColor: iconGradientColor,
                                          primaryButtonText: "Save to Gallery",
                                          primaryFunction: () {
                                            imagePickerController
                                                .drawingImageScreenShot(
                                                    pixelRatio, "save");
                                            Navigator.of(context).pop();
                                          },
                                          secondaryButtonText: "Temporily",
                                          secondaryFunction: () {
                                            imagePickerController
                                                .drawingImageScreenShot(
                                                    pixelRatio, "tempo");
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                icon: Icon(Icons.save_alt,
                                    size: controller.selectedIndex.value == 4
                                        ? 28
                                        : 20,
                                    color: controller.selectedIndex.value == 4
                                        ? Colors.white
                                        : Colors.black))),

                        //Fifth End

                        //Sixth Start
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedIndex.value == 5
                                  ? Colors.blueAccent
                                  : Colors.white,
                            ),
                            child: IconButton(
                                splashColor: Colors.transparent,
                                tooltip: "Remove",
                                onPressed: () {
                                  if (imagePickerController
                                      .imageFile.value.path.isNotEmpty) {
                                    showDialog<void>(
                                      context: context,
                                      builder: (context) {
                                        return MyAlertDialogBox(
                                          titleText: 'Discard Edits',
                                          contentText:
                                              "Are you sure want to Exit? You'll lose all the edits you've made",
                                          primaryButtonColor: cancelColor,
                                          primaryButtonText: "Discard",
                                          primaryFunction: () {
                                            imagePickerController
                                                .imageFile.value = File("");
                                            drawingShapeController
                                                .isPaintChange(false);
                                            controller.changeSelectIndex(0);
                                            setState(() {
                                              isEditText = false;
                                              isDrawingLine = false;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          secondaryButtonText: "Cancel",
                                          secondaryFunction: () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                                icon: Icon(Icons.undo,
                                    size: controller.selectedIndex.value == 5
                                        ? 28
                                        : 20,
                                    color: controller.selectedIndex.value == 5
                                        ? Colors.white
                                        : Colors.black))),
                      ],
                    )));
          },
        ));
  }
}
