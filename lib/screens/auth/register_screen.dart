import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../utils/validators.dart';
import '../../router/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _cinemaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmaCtrl = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _cinemaCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmaCtrl.dispose();
    super.dispose();
  }

  void _criarConta() {
    if (!_formKey.currentState!.validate()) return;
    // TODO (Firebase): criar usuário
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      icon: Icons.person_add_alt_1_outlined,
      title: 'Criar conta',
      subtitle: 'Cadastre-se como proprietário do cinema',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AuthFooterLink(
            text: 'Já tem conta?',
            actionLabel: 'Entrar',
            onPressed: () => context.go(AppRoutes.login),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 16,
          children: [
            AppTextField(
              controller: _nomeCtrl,
              label: 'Seu nome',
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: Validators.obrigatorio('Informe seu nome'),
            ),
            AppTextField(
              controller: _cinemaCtrl,
              label: 'Nome do cinema',
              prefixIcon: Icons.storefront_outlined,
              textInputAction: TextInputAction.next,
              validator: Validators.obrigatorio('Informe o nome do cinema'),
            ),
            EmailField(controller: _emailCtrl),
            PasswordField(controller: _senhaCtrl),
            PasswordField(
              controller: _confirmaCtrl,
              label: 'Confirmar senha',
              validator: (v) =>
                  v != _senhaCtrl.text ? 'As senhas não coincidem' : null,
            ),
            AppButton(
              label: 'Criar conta',
              icon: Icons.check,
              isLoading: _carregando,
              onPressed: _criarConta,
            ),
          ],
        ),
      ),
    );
  }
}
