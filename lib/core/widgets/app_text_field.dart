import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.style,
    this.hintStyle,
    this.cursorColor,
    this.border,
    this.focusedBorder,
    this.enabledBorder,
    this.filled,
    this.fillColor,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? cursorColor;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final bool? filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      autofocus: autofocus,
      maxLines: maxLines,
      style: style,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        hintStyle: hintStyle,
        prefixIcon: prefixWidget ?? (prefixIcon == null ? null : Icon(prefixIcon)),
        suffixIcon: suffixIcon,
        border: border,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        filled: filled,
        fillColor: fillColor,
        contentPadding: contentPadding,
      ),
    );
  }
}
