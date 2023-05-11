import 'package:chat_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final bool useCupertinoTextField;
  final void Function(String)? onSubmit;
  final TextInputAction textInputAction;
  final String? hint;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Pattern? whiteList;
  final TextInputType? keyboardType;
  final String? initText;
  final String? labelText;
  final IconData? prefixIcon;
  final bool enable;
  final int? maxText;
  final String? Function(String?)? validator;

  const Input({
    Key? key,
    this.useCupertinoTextField = false,
    this.onSubmit,
    required this.textInputAction,
    this.hint,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.whiteList,
    this.initText,
    this.labelText,
    this.prefixIcon,
    this.enable = true,
    this.maxText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initText != null) {
      controller.text = initText!;
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: initText!.length,
      );
    }

    return useCupertinoTextField
        ? CupertinoTextField(
            enabled: enable,
            textInputAction: textInputAction,
            onSubmitted: onSubmit,
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: [LengthLimitingTextInputFormatter(maxText)],
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 26, 26, 26),
              height: 1.35,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.greyLight,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            prefix: Icon(prefixIcon, size: 24, color: AppColors.greyLight),
            placeholder: hint,
            // maxLines: 1,
          )
        : TextFormField(
            validator: validator,
            enabled: enable,
            textInputAction: textInputAction,
            onFieldSubmitted: onSubmit,
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxText),
              FilteringTextInputFormatter.allow(whiteList ?? RegExp('([\\S])'))
            ],
            style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 26, 26, 26),
                height: 1.35),
            decoration: InputDecoration(
                prefixIcon: Icon(
                  prefixIcon,
                  size: 24,
                  color: AppColors.greyLight,
                ),
                prefixIconColor: AppColors.greyLight,
                contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                filled: true,
                fillColor: const Color.fromARGB(102, 230, 230, 230),
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
                labelText: labelText,
                labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6))),
          );
  }
}
