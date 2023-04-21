import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPasswordField extends StatelessWidget {
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String? hint;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final int? maxText;
  final Pattern? whiteList;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? initText;
  final IconData? prefixIcon;
  final void Function()? onTapSuffixIcon;
  final bool inputError;
  final String? Function(String?)? validator;

  const InputPasswordField({
    Key? key,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.hint,
    required this.controller,
    required this.onChanged,
    this.keyboardType,
    this.maxText,
    this.whiteList,
    this.obscureText = false,
    this.initText,
    this.prefixIcon,
    this.onTapSuffixIcon,
    this.inputError = false,
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

    return TextFormField(
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxText),
        FilteringTextInputFormatter.allow(whiteList ?? RegExp('([\\S])'))
      ],
      style: const TextStyle(
          fontSize: 16, color: Color.fromARGB(255, 26, 26, 26), height: 1.35),
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          size: 24,
          color: AppColors.greyLight,
        ),
        prefixIconColor: AppColors.greyLight,
        suffixIcon: InkWell(
          onTap: onTapSuffixIcon,
          child: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            size: 24,
            color: AppColors.greyLight,
          ),
        ),
        suffixIconColor: AppColors.greyLight,
        contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        filled: true,
        fillColor: inputError
            ? AppColors.red700
            : const Color.fromARGB(102, 230, 230, 230),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color:
                inputError ? AppColors.red700 : Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: inputError
                ? AppColors.red700
                : const Color.fromARGB(128, 130, 130, 130),
          ),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
      ),
    );
  }
}
