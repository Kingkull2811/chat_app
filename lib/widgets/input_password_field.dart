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
  final String? labelText;
  final IconData? prefixIcon;
  final void Function()? onTapSuffixIcon;
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
    this.labelText,
    this.prefixIcon,
    this.onTapSuffixIcon,
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
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(width: 1, color: AppColors.greyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(width: 1, color: AppColors.greyLight),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(width: 1, color: AppColors.greyLight),
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
          borderSide: const BorderSide(width: 1, color: AppColors.red700),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
      ),
    );
  }
}
