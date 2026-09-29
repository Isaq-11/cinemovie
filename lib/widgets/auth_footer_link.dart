import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.text,
    required this.actionLabel,
    required this.onPressed,
  });

  final String text;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        const SizedBox(width: 4),
        AppButton(
          label: actionLabel,
          variant: AppButtonVariant.text,
          expanded: false,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
