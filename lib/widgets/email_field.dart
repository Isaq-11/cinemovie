import 'package:cine_movie/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import '../utils/validators.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.next,
    this.validator = Validators.email,
  });

  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'E-mail',
      prefixIcon: Icons.mail_outline,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
      validator: validator,
      autofillHints: const [AutofillHints.email],
    );
  }
}
