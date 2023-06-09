import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.primaryColor,
          ),
        ),
        content: Form(
          key: _formKey,
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              validator: (value) {
                if (value != null &&
                    (double.parse(value) > 10.0 || double.parse(value) < 0)) {
                  return 'The point must be between 0.0 and 10.0';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.greyLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.greyLight),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.greyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 1,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.red700),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('([\\S])'))
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Done'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop(controller.text);
              }
            },
          ),
        ],
      );
}
