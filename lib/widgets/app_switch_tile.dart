import 'package:flutter/material.dart';

class AppSwitchTile extends StatelessWidget {
  const AppSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onChanged: onChanged,
    );
  }
}
