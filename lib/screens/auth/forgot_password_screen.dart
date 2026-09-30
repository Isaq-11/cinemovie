import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
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
    // TODO (Firebase): sendPasswordResetEmail
    showAppSnackBar(context, 'Link de recuperação enviado.');
    context.go(AppRoutes.login);
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
            EmailField(controller: _emailCtrl),
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
