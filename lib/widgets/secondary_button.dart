import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String? text;
  final Widget? content;
  final Function()? onTap;

  const SecondaryButton({Key? key, this.text, this.content, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var child = (text == null)
        ? content
        : Container(
            constraints: const BoxConstraints(
              minHeight: 50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(text ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ],
            ));
    return ButtonTheme(
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          backgroundColor: const MaterialStatePropertyAll(Colors.white),
          foregroundColor: const MaterialStatePropertyAll(Colors.transparent),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                  style: BorderStyle.solid),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
