import 'package:flutter/material.dart';
import '../../utils/validators.dart';
import '../../widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: enviar e-mail de recuperação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link de recuperação enviado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      icon: Icons.lock_reset,
      title: 'Recuperar senha',
      subtitle:
          'Informe seu e-mail e enviaremos um link para redefinir a senha',
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 16,
          children: [
            AppTextField(
              controller: _emailCtrl,
              label: 'E-mail',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
            ),
            AppButton(
              label: 'Enviar link',
              icon: Icons.send,
              onPressed: _enviar,
            ),
          ],
        ),
      ),
    );
  }
}
