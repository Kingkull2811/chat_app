import 'package:chat_app/screens/chats/chat.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth_android/types/auth_messages_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

import '../screens/chats/chat_state.dart';
import '../screens/main/main_app.dart';
import '../services/database.dart';
import '../widgets/message_dialog.dart';

void showLoading(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        );
      });
}

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
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            children: [
              Image.asset(
                'assets/images/ic_no_internet.png',
                height: 150,
                width: 150,
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
                child: Text(buttonLabel ?? 'OK')),
          ],
        );
      });
}

Future<void> showCupertinoMessageDialog(
    BuildContext context, String? title, String? content,
    {Function()? onClose, String? buttonLabel,bool barrierDismiss = false}) async {
  await showDialog(
      barrierDismissible: barrierDismiss,
      context: context,
      builder: (context) {
        return MessageDialog(
          title: title,
          content: content,
          buttonLabel: buttonLabel,
          onClose: onClose,
        );
      });
}

void backToChat(BuildContext context) {
  // Reset app mode
  //resetSwitchAppMode();
  Navigator.popUntil(context, (route) => route.isFirst);
  DatabaseService().gpsInfo = null;
  try {
    (DatabaseService().chatKey?.currentState as MainAppState).changeTabToChat();
    (DatabaseService().chatKey?.currentState as MainAppState).reloadPage();
  } catch (_) {}
  try {
    (DatabaseService().chatKey?.currentState as ChatsPageState).reloadPage();
  } catch (_) {}
}

AndroidAuthMessages androidLocalAuthMessage(
        //BuildContext context,
        ) =>
    const AndroidAuthMessages(
      cancelButton: 'OK',
      goToSettingsButton: 'Setting',
      goToSettingsDescription:
          'Biometrics is not set up on your device. Please either enable TouchId or FaceId on your phone.',
    );

IOSAuthMessages iosLocalAuthMessages(
        //BuildContext context,
        ) =>
    const IOSAuthMessages(
      cancelButton: 'OK',
      goToSettingsButton: 'Setting',
      goToSettingsDescription:
          'Biometrics is not set up on your device. Please either enable TouchId or FaceId on your phone.',
    );
