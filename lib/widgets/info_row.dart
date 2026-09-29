import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),

        const SizedBox(width: 8),

        Text(
          label,
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),

        const Spacer(),

        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
