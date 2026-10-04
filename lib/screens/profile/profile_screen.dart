import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../../services/auth_service.dart';

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
      await AuthService.instance.logout();
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
          StreamBuilder(
            stream: AuthService.instance.userChanges,
            initialData: AuthService.instance.currentUser,
            builder: (context, snap) {
              final user = snap.data;
              final nome = user?.displayName ?? '—';
              final inicial = nome.isNotEmpty && nome != '—'
                  ? nome[0].toUpperCase()
                  : '?';

              return Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: cores.primaryContainer,
                      child: Text(
                        inicial,
                        style: TextStyle(
                          fontSize: 32,
                          color: cores.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormSection(
                    title: 'Conta',
                    icon: Icons.person_outline,
                    child: Column(
                      spacing: 12,
                      children: [
                        InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'Nome',
                          value: nome,
                        ),
                        InfoRow(
                          icon: Icons.storefront_outlined,
                          label: 'Cinema',
                          value: 'Cine Exemplo',
                        ),
                        InfoRow(
                          icon: Icons.mail_outline,
                          label: 'E-mail',
                          value: user?.email ?? '—',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
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
