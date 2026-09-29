import 'package:flutter/material.dart';

class FormSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;
  final Color? color;

  const FormSection({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final sectionColor = color ?? Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: sectionColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: sectionColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
