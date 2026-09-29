import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../widgets/widgets.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Senha',
    this.textInputAction,
    this.validator = Validators.senha,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      obscureText: _oculto,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      suffixIcon: IconButton(
        tooltip: _oculto ? 'Mostrar senha' : 'Ocultar senha',
        icon: Icon(_oculto ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() => _oculto = !_oculto);
        },
      ),
    );
  }
}
