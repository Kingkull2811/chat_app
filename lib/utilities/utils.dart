import 'dart:developer';
import 'dart:io';

import 'package:chat_app/utilities/enum/biometrics_button_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

String getBiometricsButtonPath({
  BiometricButtonType? buttonType,
}) {
  if (buttonType == BiometricButtonType.face) {
    return 'assets/images/ic_face_id.png';
  }
  if (buttonType == BiometricButtonType.touch) {
    return 'assets/images/ic_touch_id.png';
  }
  return 'assets/images/ic_face_touch_id.png';
}

///use for validate confirm set new password
// Minimum 1 Upper case
// Minimum 1 lowercase
// Minimum 1 Numeric Number
// Minimum 1 Special Character
// Common Allow Character ( ! @ # $ & * ~ )
bool validateStructure(String value) {
  RegExp regExp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  return regExp.hasMatch(value);
}

bool isNotNullOrEmpty(dynamic obj) => !isNullOrEmpty(obj);

/// For String, List, Map
bool isNullOrEmpty(dynamic obj) =>
    obj == null ||
        ((obj is String || obj is List || obj is Map) && obj.isEmpty);

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? imagePath;
  try {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImage != null){
      imagePath = File(pickImage.path);
    }
  }
  catch(e){
    log(e.toString());
  }
  return imagePath;
}
Future<File?> pickImageFromCamera(BuildContext context) async {
  File? imagePath;
  try {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if(pickImage != null){
      imagePath = File(pickImage.path);
    }
  }
  catch(e){
    log(e.toString());
  }
  return imagePath;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(pickVideo != null){
      video = File(pickVideo.path);
    }
  }
  catch(e){
    log(e.toString());
  }
  return video;
}

// Future<GiphyGif?> pickGIF(BuildContext context) async {
//   GiphyGif? gif;
//   try {
//     gif = await Giphy.getGif(
//       context: context,
//       apiKey: 'pwXu0t7iuNVm8VO5bgND2NzwCpVH9S0F',
//     );
//   } catch (e) {
//     showSnackBar(context: context, content: e.toString());
//   }
//   return gif;
// }
// void showSnackBar({required BuildContext context, required String content}) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(content),
//     ),
//   );
// }
