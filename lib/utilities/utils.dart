import 'dart:developer';
import 'dart:io';

import 'package:chat_app/utilities/enum/biometrics_button_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
// bool validateStructure(String value) {
//   RegExp regExp =
//       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
//   return regExp.hasMatch(value);
// }

bool isNotNullOrEmpty(dynamic obj) => !isNullOrEmpty(obj);

/// For String, List, Map
bool isNullOrEmpty(dynamic obj) =>
    obj == null ||
    ((obj is String || obj is List || obj is Map) && obj.isEmpty);

Future<File?> pickPhoto(
  BuildContext context,
  ImageSource imageSource,
) async {
  try {
    final pickedFile = (imageSource == ImageSource.camera
        ? await ImagePicker().pickImage(
            source: ImageSource.camera,
            imageQuality: 50,
            maxWidth: 2048,
            maxHeight: 2048,
          )
        : await ImagePicker().pickImage(source: ImageSource.gallery));
    if (isNullOrEmpty(pickedFile)) {
      return null;
    }
    final applicationPath = await getApplicationDocumentsDirectory();

    File image = File(pickedFile!.path);
    File newImage =
        File('${applicationPath.path}/${basename(pickedFile.name)}');
    newImage.writeAsBytes(File(pickedFile.path).readAsBytesSync());

    return imageSource == ImageSource.camera ? newImage : image;
  } on PlatformException catch (e) {
    log(e.toString());
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Failed to pick image!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
    return null;
  }
}

// Future<File?> cropperPhoto({File? imageFile}) async {
//   if (imageFile == null) {
//     return null;
//   }
//   CroppedFile? photoCropper =
//       await ImageCropper().cropImage(sourcePath: imageFile.path);
//   return isNotNullOrEmpty(photoCropper) ? File(photoCropper!.path) : null;
// }
//
// Future<File?> pickImageFromGallery(BuildContext context) async {
//   File? imagePath;
//   try {
//     final pickImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickImage != null) {
//       imagePath = File(pickImage.path);
//     }
//   } catch (e) {
//     log(e.toString());
//   }
//   return imagePath;
// }

Future<File?> pickImageFromCamera(BuildContext context) async {
  File? imagePath;
  try {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickImage != null) {
      imagePath = File(pickImage.path);
    }
  } catch (e) {
    log(e.toString());
  }
  return imagePath;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickVideo != null) {
      video = File(pickVideo.path);
    }
  } catch (e) {
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

List<T> modelBuilder<M, T>(
        List<M> models, T Function(int index, M model) builder) =>
    models
        .asMap()
        .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
        .values
        .toList();
