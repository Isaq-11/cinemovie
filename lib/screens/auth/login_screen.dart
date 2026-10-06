import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../router/app_routes.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _carregando = true);
    try {
      await AuthService.instance.login(_emailCtrl.text, _senhaCtrl.text);
    } on AuthException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, isError: true);
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.local_movies_outlined,
      title: 'CineMovie',
      subtitle: 'Entre para gerenciar seu cinema',
      footer: AuthFooterLink(
        text: 'Ainda não tem conta?',
        actionLabel: 'Cadastre-se',
        onPressed: () => context.push(AppRoutes.register),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 16,
          children: [
            EmailField(controller: _emailCtrl),
            PasswordField(controller: _senhaCtrl),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(
                variant: AppButtonVariant.text,
                expanded: false,
                label: 'Esqueci minha senha',
                onPressed: () => context.push(AppRoutes.forgotPassword),
              ),
            ),
            AppButton(
              label: 'Entrar',
              icon: Icons.login,
              isLoading: _carregando,
              onPressed: _entrar,
            ),
          ],
        ),
      ),
    );
  }
}
