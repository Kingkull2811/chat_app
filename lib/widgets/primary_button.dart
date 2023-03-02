import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final onTap;
  final bool isActive;

  const PrimaryButton({
    Key? key,
    this.text,
    this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 16 * 4;
    return ButtonTheme(
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          overlayColor: MaterialStatePropertyAll(
            Theme.of(context).primaryColor,
          ),
          backgroundColor:
              MaterialStatePropertyAll(Theme.of(context).primaryColor),
          foregroundColor: const MaterialStatePropertyAll(Colors.transparent),
          textStyle: const MaterialStatePropertyAll(
            TextStyle(color: Colors.white),
          ),
        ),
        child: Container(
          width: width / 2,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          constraints: const BoxConstraints(
            minHeight: 50,
            maxHeight: 50,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            child: Text(
              text ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
