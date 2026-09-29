import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final String? suffixText;
  final Widget? suffixIcon;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.prefixIcon,
    this.suffixText,
    this.suffixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autofillHints,
    this.obscureText = false,
    this.enabled = true,
  }) : assert(
         controller == null || initialValue == null,
         'Não use controller e initialValue ao mesmo tempo.',
       );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      obscureText: obscureText,
      enabled: enabled,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixText: suffixText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
