import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  static Future showScaleAlertBox({
    required BuildContext context,
    required String title,
    IconData? icon,
    required String text,
    required String firstButton,
  }) {
    return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              backgroundColor: const Color(0xFFDEEEFB),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              title: Center(
                  child: Text(
                title,
                style: const TextStyle(color: Colors.black),
              )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  // OPTIONAL BUTTON
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  color: AppColors.primaryColor,
                  child: Text(
                    firstButton,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 128),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
    );
  }
}
