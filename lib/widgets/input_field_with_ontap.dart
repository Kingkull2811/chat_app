import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../utilities/utils.dart';

class InputField extends StatelessWidget {
  final BuildContext context;
  final TextEditingController? controller;
  final TextInputAction? inputAction;
  final String? initText;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool showSuffix;
  final bool isShow;
  final Function()? onTap;
  final Function()? onTapSuffix;
  final bool readOnly;
  final String? iconPath;
  final int? maxText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextAlign? textAlign;

  const InputField({
    Key? key,
    required this.context,
    this.controller,
    this.inputAction,
    this.initText,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.showSuffix = false,
    this.isShow = false,
    this.onTap,
    this.onTapSuffix,
    this.readOnly = false,
    this.iconPath,
    this.maxText,
    this.keyboardType,
    this.validator,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      validator: validator,
      inputFormatters: [LengthLimitingTextInputFormatter(maxText)],
      textAlign: textAlign ?? TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: inputAction ?? TextInputAction.done,
      onFieldSubmitted: (value) {},
      onChanged: (_) {},
      keyboardType: keyboardType ?? TextInputType.text,
      style: const TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 26, 26, 26),
      ),
      decoration: InputDecoration(
          prefixIcon: isNotNullOrEmpty(prefixIcon)
              ? Icon(prefixIcon, size: 24, color: AppColors.greyLight)
              : isNotNullOrEmpty(iconPath)
                  ? Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Image.asset(
                        '$iconPath',
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                        color: AppColors.greyLight,
                      ),
                    )
                  : null,
          prefixIconColor: AppColors.greyLight,
          suffixIcon: showSuffix
              ? InkWell(
                  onTap: onTapSuffix,
                  child: Icon(
                    isShow ? Icons.expand_more : Icons.navigate_next,
                    size: 24,
                    color: AppColors.greyLight,
                  ),
                )
              : null,
          suffixIconColor: AppColors.greyLight,
          contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
          filled: true,
          fillColor: const Color.fromARGB(102, 230, 230, 230),
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
          labelText: labelText,
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6))),
    );
  }
}
