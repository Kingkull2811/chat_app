import 'package:chat_app/screens/authenticator/login/login_page.dart';
import 'package:chat_app/screens/chats/chat.dart';
import 'package:chat_app/utilities/app_constants.dart';
import 'package:chat_app/utilities/shared_preferences_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_android/types/auth_messages_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

import '../screens/authenticator/login/login_bloc.dart';
import '../screens/main/main_app.dart';
import '../services/database.dart';
import '../widgets/message_dialog.dart';
import '../widgets/primary_button.dart';

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

void logout(BuildContext? context) async {
  SharedPreferencesStorage().resetDataWhenLogout();
  if (context != null) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
          child: const LoginPage(),
        ),
      ),
      (route) => false,
    );
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
                child: Text(buttonLabel ?? 'OK')),
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

Future<void> showSuccessBottomSheet(
    BuildContext context, {
      bool isDismissible = false,
      bool enableDrag = false,
      required String titleMessage,
      required String contentMessage,
      required String buttonLabel,
      required Function() onTap,
    }) async {
  await showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        height: 350,
        color: AppConstants().grey630,
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
                      padding:  EdgeInsets.only(top: 16),
                      child: Icon(
                        Icons.verified_outlined,
                        size: 150,

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        (titleMessage),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      width: 300,
                      child: Text(
                        (contentMessage),
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
