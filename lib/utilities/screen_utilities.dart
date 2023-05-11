import 'package:chat_app/routes.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:chat_app/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth_android/types/auth_messages_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

import '../widgets/message_dialog.dart';
import '../widgets/primary_button.dart';

void showBlankPage(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container();
      });
}

void showLoading(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ),
        );
      });
}

void logout(BuildContext? context) async {
  SharedPreferencesStorage().resetDataWhenLogout();
  if (context != null) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (route) => false);
  }
}

void logoutIfNeed(BuildContext? context) async {
  final passwordExpiredTime =
      SharedPreferencesStorage().getRefreshTokenExpired();
  if (passwordExpiredTime.isEmpty) {
    logout(context);
  } else {
    try {
      DateTime expiredDate = DateTime.parse(passwordExpiredTime);
      if (expiredDate.isBefore(DateTime.now())) {
        logout(context);
      }
    } catch (error) {
      logout(context);
    }
  }
}

clearFocus(BuildContext context) {
  if (FocusScope.of(context).hasFocus) {
    FocusScope.of(context).unfocus();
  } else {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

AndroidAuthMessages androidLocalAuthMessage(//BuildContext context,
        ) =>
    const AndroidAuthMessages(
      cancelButton: 'OK',
      goToSettingsButton: 'Setting',
      goToSettingsDescription:
          'Biometrics is not set up on your device. Please either enable TouchId or FaceId on your phone.',
    );

IOSAuthMessages iosLocalAuthMessages(//BuildContext context,
        ) =>
    const IOSAuthMessages(
      cancelButton: 'OK',
      goToSettingsButton: 'Setting',
      goToSettingsDescription:
          'Biometrics is not set up on your device. Please either enable TouchId or FaceId on your phone.',
    );

Future<void> showMessageNoInternetDialog(
  BuildContext context, {
  Function()? onClose,
  String? buttonLabel,
}) async {
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            AppConstants.noInternetTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Image.asset(
                  'assets/images/ic_no_internet.png',
                  height: 150,
                  width: 150,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: const Text(
                  AppConstants.noInternetContent,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                if (onClose != null) {
                  onClose();
                }
              },
              child: Text(buttonLabel ?? 'OK'),
            ),
          ],
        );
      });
}

Future<void> showCupertinoMessageDialog(
  BuildContext context,
  String? title, {
  String? content,
  Function()? onCloseDialog,
  String? buttonLabel,

  /// false = user must tap button, true = tap outside dialog
  bool barrierDismiss = false,
}) async {
  await showDialog(
      barrierDismissible: barrierDismiss,
      context: context,
      builder: (context) {
        return MessageDialog(
          title: title,
          content: content,
          buttonLabel: buttonLabel,
          onClose: onCloseDialog,
        );
      });
}

Future<void> showMessageTwoOption(
  BuildContext context,
  String? title, {
  String? content,
  Function()? onCancel,
  String? cancelLabel,
  Function()? onOk,
  String? okLabel,

  /// false = user must tap button, true = tap outside dialog
  bool barrierDismiss = false,
}) async {
  await showDialog(
      barrierDismissible: barrierDismiss,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title == null ? null : Text(title),
          content: content == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(content),
                ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                if (onCancel != null) {
                  onCancel();
                }
              },
              child: Text(cancelLabel ?? 'Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                if (onOk != null) {
                  onOk();
                }
              },
              child: Text(
                okLabel ?? 'OK',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      });
}

Future<void> showSuccessBottomSheet(
  BuildContext context, {
  bool isDismissible = false,
  bool enableDrag = false,
  String? titleMessage,
  String? contentMessage,
  String? buttonLabel,
  required Function() onTap,
}) async {
  await showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return isDismissible;
      },
      child: Container(
        height: 350,
        color: AppColors.grey630,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Icon(
                        Icons.verified_outlined,
                        size: 150,
                        color: AppColors.green600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        titleMessage ?? 'Successfully!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      width: 300,
                      child: Text(
                        contentMessage ?? '',
                        //maxLines: 3,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: PrimaryButton(
                  text: buttonLabel,
                  onTap: onTap,
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget inputTextWithLabel(
  BuildContext context, {
  TextEditingController? controller,
  TextInputAction? inputAction,
  String? initText,
  String? labelText,
  String? hintText,
  IconData? prefixIcon,
  bool showSuffix = false,
  bool isShow = false,
  Function()? onTap,
  Function()? onTapSuffix,
  bool readOnly = false,
  String? iconPath,
  int? maxText,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  if (initText != null) {
    controller?.text = initText;
    controller?.selection = TextSelection(
      baseOffset: 0,
      extentOffset: initText.length,
    );
  }
  return TextFormField(
    onTap: onTap,
    readOnly: readOnly,
    controller: controller,
    validator: validator,
    inputFormatters: [LengthLimitingTextInputFormatter(maxText)],
    textAlign: TextAlign.start,
    textAlignVertical: TextAlignVertical.center,
    textInputAction: inputAction ?? TextInputAction.done,
    onFieldSubmitted: (value) {},
    onChanged: (_) {},
    keyboardType: keyboardType ?? TextInputType.text,
    style: const TextStyle(
      fontSize: 16,
      color: Color.fromARGB(255, 26, 26, 26),
    ),
    decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        prefixIcon: isNotNullOrEmpty(prefixIcon)
            ? Icon(prefixIcon, size: 24, color: AppColors.greyLight)
            : isNotNullOrEmpty(iconPath)
                ? Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Image.asset(
                      '$iconPath',
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                      color: AppColors.greyLight,
                    ),
                  )
                : null,
        prefixIconColor: AppColors.greyLight,
        suffixIcon: showSuffix
            ? InkWell(
                onTap: onTapSuffix,
                child: Icon(
                  isShow ? Icons.expand_more : Icons.navigate_next,
                  size: 24,
                  color: AppColors.greyLight,
                ),
              )
            : null,
        suffixIconColor: AppColors.greyLight,
        contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        filled: true,
        fillColor: const Color.fromARGB(102, 230, 230, 230),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1,
            color: Color.fromARGB(128, 130, 130, 130),
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6))),
  );
}

Future<String?> pickImage(BuildContext context) async {
  String? imagePath;
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              imagePath = await pickPhoto(ImageSource.camera);
            },
            child: Text(
              'Take a photo from camera',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              imagePath = await pickPhoto(ImageSource.gallery);
            },
            child: Text(
              'Choose a photo from gallery',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ),
      );
    },
  );
  return imagePath;
}
