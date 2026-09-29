import 'package:flutter/material.dart';

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.label, this.icon, this.color});

  final String label;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = color != null
        ? color!.withValues(alpha: 0.18)
        : colorScheme.secondaryContainer;

    final foregroundColor = color ?? colorScheme.onSecondaryContainer;

    return Chip(
      label: Text(label),
      labelStyle: TextStyle(color: foregroundColor),
      avatar: icon != null
          ? Icon(icon, size: 16, color: foregroundColor)
          : null,
      backgroundColor: backgroundColor,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
