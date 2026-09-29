import 'package:flutter/material.dart';
import 'app_text_field.dart';

class AppPickerField extends StatelessWidget {
  const AppPickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.valueText,
    required this.onTap,
    this.validator,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? valueText;
  final VoidCallback onTap;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: IgnorePointer(
        child: AppTextField(
          key: ValueKey(valueText),
          label: label,
          hint: hint,
          prefixIcon: icon,
          initialValue: valueText,
          validator: validator,
        ),
      ),
    );
  }
}
