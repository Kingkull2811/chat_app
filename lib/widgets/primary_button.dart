import 'package:flutter/material.dart';


class PrimaryButton extends StatelessWidget {
  final String? text;
  final Function() onTap;
  final bool nonOverflow;

  const PrimaryButton({
    Key? key,
    this.text,
    required this.onTap,
    this.nonOverflow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 16 * 2 - 16 * 2;
    return ButtonTheme(
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
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
        child: nonOverflow
            ? Container(
                constraints: const BoxConstraints(
                  minHeight: 50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      text ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: width,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                constraints: const BoxConstraints(minHeight: 50, maxHeight: 100),
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
