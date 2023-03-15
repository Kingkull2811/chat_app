import 'package:chat_app/utilities/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageDialog2Action extends StatelessWidget {
  final String title;
  final String content;
  final Function() onLeftTap;
  final Function() onRightTap;
  final String? buttonLeftLabel;
  final String? buttonRightLabel;
  final bool isRedLabel;

  const MessageDialog2Action({
    Key? key,
    required this.title,
    required this.content,
    required this.onLeftTap,
    required this.onRightTap,
    this.buttonLeftLabel,
    this.buttonRightLabel,
    this.isRedLabel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: onLeftTap,
          child: Text(
            buttonLeftLabel ?? 'Cancel',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        CupertinoDialogAction(
          onPressed: onRightTap,
          child: Text(
            buttonRightLabel ?? 'OK',
            style: TextStyle(
              fontSize: 18,
              color: isRedLabel? AppConstants().red700: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
