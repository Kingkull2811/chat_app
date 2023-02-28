import 'package:flutter/material.dart';
import 'package:local_auth_android/types/auth_messages_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

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
