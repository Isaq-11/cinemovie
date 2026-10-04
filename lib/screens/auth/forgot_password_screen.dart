import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../widgets/widgets.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _carregando = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);
    try {
      await AuthService.instance.resetPassword(_emailCtrl.text);
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Se o e-mail estiver cadastrado, enviaremos o link de recuperação.',
      );
      context.go(AppRoutes.login);
    } on AuthException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
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
              isLoading: _carregando,
            ),
          ],
        ),
      ),
    );
  }
}
