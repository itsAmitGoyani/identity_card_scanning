import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:identity_card_scanning/util/app_text_theme.dart';
import 'package:identity_card_scanning/util/color_constants.dart';

class KTextFormField extends StatelessWidget {
  final String? labelText, hintText;
  final bool readOnly, obscureText;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? minLines, maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const KTextFormField({
    Key? key,
    this.readOnly = false,
    this.obscureText = false,
    this.labelText,
    this.hintText,
    this.validator,
    this.controller,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.minLines,
    this.maxLines,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      obscureText: obscureText,
      style: AppTextTheme.bodyText16,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      onTap: onTap,
      inputFormatters: inputFormatters,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxHeight: 70),
        isDense: true,
        contentPadding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        labelText: labelText,
        hintText: hintText,
        hintStyle: AppTextTheme.bodyText18,
        fillColor: primaryColor.withOpacity(0.2),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: Colors.red),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: primaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: primaryColor),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2),
        ),
      ),
    );
  }
}
