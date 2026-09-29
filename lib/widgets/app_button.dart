import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = AppButtonVariant.filled,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final AppButtonVariant variant;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          )
        : Text(label);

    Widget button;

    switch (variant) {
      case AppButtonVariant.filled:
        button = icon != null
            ? FilledButton.icon(
                onPressed: isLoading ? null : onPressed,
                icon: Icon(icon),
                label: child,
              )
            : FilledButton(
                onPressed: isLoading ? null : onPressed,
                child: child,
              );

      case AppButtonVariant.outlined:
        button = icon != null
            ? OutlinedButton.icon(
                onPressed: isLoading ? null : onPressed,
                icon: Icon(icon),
                label: child,
              )
            : OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                child: child,
              );

      case AppButtonVariant.text:
        button = icon != null
            ? TextButton.icon(
                onPressed: isLoading ? null : onPressed,
                icon: Icon(icon),
                label: child,
              )
            : TextButton(onPressed: isLoading ? null : onPressed, child: child);
    }

    if (!expanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
