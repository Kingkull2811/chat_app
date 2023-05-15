import 'package:flutter/material.dart';

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;

  const TextDialogWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  TextDialogWidgetState createState() => TextDialogWidgetState();
}

class TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Done'),
            onPressed: () => Navigator.of(context).pop(controller.text),
          )
        ],
      );
}
