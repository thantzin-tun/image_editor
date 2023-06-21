// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_editor_app/utils/constants.dart';
import 'package:image_editor_app/widgets/textWidget.dart';

class ImagePickerController extends GetxController {
  late Rx<File> imageFile;
  ImagePicker picker = ImagePicker();

  //This four variable is used for drawing stroke with Color
  RxDouble pixelRatio = 0.0.obs;
  GlobalKey globalKey = GlobalKey();

  ImagePickerController() {
    imageFile = Rx<File>(File(""));
  }

  //Get Image from Gallery
  void getImageFromGallery() async {
    final pickImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      imageFile.value = File(pickImage.path);
    } else {
      return;
    }
  }

  //Get Image from Take Picture
  void getImageFromCamera() async {
    final pickImage = await picker.pickImage(source: ImageSource.camera);
    if (pickImage != null) {
      imageFile.value = File(pickImage.path);
    } else {
      return;
    }
  }

  //Crop Image and Get this image
  cropImage() async {
    final cropImage = await ImageCropper()
        .cropImage(sourcePath: imageFile.value.path, uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ], aspectRatioPresets: [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio16x9,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.square,
    ]);
    if (cropImage != null) {
      imageCache.clear();
      imageFile.value = File(cropImage.path);
      imageFile.update((val) => cropImage);
    }
  }

  //Save Edit Image to Gallery
  void saveImage() async {
    final saveImage = File(imageFile.value.path).readAsBytesSync();
    try {
      await ImageGallerySaver.saveImage(saveImage,
          name: "Editor Photo", quality: 80);
      Get.snackbar("Success", "Save to Gallery",
          titleText: const MyTextWidget(
            text: "Success",
            color: defaultWhiteColor,
            fontSize: 17,
          ),
          messageText: const MyTextWidget(
            text: "Save to Gallery",
            color: defaultWhiteColor,
            fontSize: 13,
          ),
          snackPosition: SnackPosition.TOP,
          borderRadius: 5.0,
          backgroundColor: defaultBlackColor,
          isDismissible: true,
          icon: const Icon(
            Icons.save_sharp,
            color: iconGradientColor,
          ),
          dismissDirection: DismissDirection.startToEnd,
          animationDuration: const Duration(milliseconds: 800));
    } catch (e) {
      Get.snackbar("Failed", "something went wrong!",
          titleText: const MyTextWidget(
            text: "Success",
            color: defaultWhiteColor,
            fontSize: 17,
          ),
          messageText: const MyTextWidget(
            text: "Save to Gallery",
            color: defaultWhiteColor,
            fontSize: 13,
          ),
          snackPosition: SnackPosition.TOP,
          borderRadius: 5.0,
          backgroundColor: defaultBlackColor,
          isDismissible: true,
          icon: const Icon(
            Icons.save_sharp,
            color: iconGradientColor,
          ),
          dismissDirection: DismissDirection.startToEnd,
          animationDuration: const Duration(milliseconds: 800));
    } //Get SnackBAr
  }

  //Drawing Image Screenshot Saved Method
  void drawingImageScreenShot(double pixelRatio, options) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: pixelRatio);

    final byteData = await image.toByteData(format: ImageByteFormat.png);

    final imageBytes = byteData?.buffer.asUint8List();

    if (imageBytes != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath =
            await File('${directory.path}/container_image.png').create();
        final saveImage = await imagePath.writeAsBytes(imageBytes);
        //
        if (options == "tempo") {
          print("Temporily Save!");
        } else {
          final result = await ImageGallerySaver.saveImage(imageBytes);
          Get.snackbar("Success", "Save to Gallery",
              titleText: const MyTextWidget(
                text: "Success",
                color: defaultWhiteColor,
                fontSize: 17,
              ),
              messageText: const MyTextWidget(
                text: "Save to Gallery",
                color: defaultWhiteColor,
                fontSize: 13,
              ),
              snackPosition: SnackPosition.TOP,
              borderRadius: 5.0,
              backgroundColor: defaultBlackColor,
              isDismissible: true,
              icon: const Icon(
                Icons.save_sharp,
                color: iconGradientColor,
              ),
              dismissDirection: DismissDirection.startToEnd,
              animationDuration: const Duration(milliseconds: 800));
        }
      } catch (e) {
        print('Error saving image: $e');
      }
    }
  }

}
