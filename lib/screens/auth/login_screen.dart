import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../router/app_routes.dart';

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

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;
    // TODO (Firebase): autenticar
    context.go(AppRoutes.home);
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
