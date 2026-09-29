import 'package:flutter/material.dart';

class FormActionBar extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final IconData? primaryIcon;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool isLoading;
  final Color? primaryColor;

  const FormActionBar({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIcon,
    this.secondaryLabel,
    this.onSecondary,
    this.isLoading = false,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final primaryButton = FilledButton.icon(
      onPressed: isLoading ? null : onPrimary,
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(primaryIcon ?? Icons.check),
      label: Text(isLoading ? 'Aguarde...' : primaryLabel),
      style: FilledButton.styleFrom(backgroundColor: primaryColor),
    );

    final content = SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (secondaryLabel != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : onSecondary,
                  child: Text(secondaryLabel!),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(flex: 2, child: primaryButton),
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: content,
    );
  }
}
