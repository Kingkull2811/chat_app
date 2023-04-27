import 'dart:developer';
import 'dart:io';

import 'package:chat_app/utilities/enum/biometrics_button_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

Future<String> pickPhoto(
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
    if (pickedFile == null) {
      return '';
    }

    // final appDocDir = await getApplicationDocumentsDirectory();
    // final tempDir = await getTemporaryDirectory();
    //
    File image = File(pickedFile.path);
    // File newImage = File(join(appDocDir.path, basename(pickedFile.path)));
    // newImage.writeAsBytes(File(pickedFile.path).readAsBytesSync());

    // return imageSource == ImageSource.camera
    //     ? join(appDocDir.path, basename(newImage.path))
    //     : image.path;
    return image.path;
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
    return '';
  }
}

Future<String> pickVideo(BuildContext context, ImageSource source) async {
  try {
    final pickVideo = await ImagePicker().pickVideo(source: source);
    if (pickVideo != null) {
      final video = File(pickVideo.path);
      // final tempDir = await getTemporaryDirectory();
      // List<String> parts = video.path.split('cache/');
      // if (parts.length > 1) {
      //   String pathAfterCache = parts[1];
      //   print(pathAfterCache);
      // } else {
      //   print("Path doesn't contain 'cache/' segment");
      // }
      // String videoPath = join(tempDir.path, video.path.split('cache/')[1]);

      return video.path;
    } else {
      return '';
    }
  } on PlatformException catch (e) {
    log(e.toString());
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Failed to pick video!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
    return '';
  }
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

String printDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(
    duration.inMinutes.remainder(60),
  );
  String twoDigitSeconds = twoDigits(
    duration.inSeconds.remainder(60),
  );
  if (duration.inHours > 0) {
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
  return "$twoDigitMinutes:$twoDigitSeconds";
}

String formatDateString(String? input, {String format = 'yyyy/M/dd'}) {
  try {
    if (input == null) {
      return '';
    }
    DateTime inputDate = DateTime.parse(input);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(inputDate);
  } catch (ignore) {
    return '';
  }
}
