import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _sair(BuildContext context) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Sair da conta?',
      message: 'Você precisará entrar novamente.',
      confirmLabel: 'Sair',
    );
    if (ok && context.mounted) {
      // TODO (Firebase): signOut
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: cores.primaryContainer,
              child: Text(
                'F',
                style: TextStyle(fontSize: 32, color: cores.onPrimaryContainer),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const FormSection(
            title: 'Conta',
            icon: Icons.person_outline,
            child: Column(
              spacing: 12,
              children: [
                InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Nome',
                  value: 'Fulano de Tal',
                ),
                InfoRow(
                  icon: Icons.storefront_outlined,
                  label: 'Cinema',
                  value: 'Cine Exemplo',
                ),
                InfoRow(
                  icon: Icons.mail_outline,
                  label: 'E-mail',
                  value: 'fulano@email.com',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Sair da conta',
            icon: Icons.logout,
            variant: AppButtonVariant.outlined,
            onPressed: () => _sair(context),
          ),
        ],
      ),
    );
  }
}
