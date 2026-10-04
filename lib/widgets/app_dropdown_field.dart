import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: ValueKey(value),
      initialValue: value,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(value: item, child: Text(itemLabel(item)));
      }).toList(),
    );
  }
}
