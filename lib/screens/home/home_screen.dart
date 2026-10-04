import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../mocks/mock_data.dart';
import '../../widgets/widgets.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CineMovie'),
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StreamBuilder(
            stream: AuthService.instance.userChanges,
            initialData: AuthService.instance.currentUser,
            builder: (context, snap) {
              final primeiro = snap.data?.displayName?.split(' ').first ?? '';

              return Text(
                primeiro.isEmpty ? 'Olá!' : 'Olá, $primeiro!',
                style: tema.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          Text(
            'Resumo do seu cinema',
            style: tema.textTheme.bodyMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.movie_outlined,
                  value: '${mockFilmes.length}',
                  label: 'Filmes',
                  onTap: () => context.go(AppRoutes.movies),
                ),
              ),
              Expanded(
                child: StatCard(
                  icon: Icons.meeting_room_outlined,
                  value: '${mockSalas.length}',
                  label: 'Salas',
                  onTap: () => context.go(AppRoutes.theaters),
                ),
              ),
              Expanded(
                child: StatCard(
                  icon: Icons.event_outlined,
                  value: '${mockSessoes.length}',
                  label: 'Sessões',
                  onTap: () => context.go(AppRoutes.sessions),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionTitle(
            title: 'Próximas sessões',
            actionLabel: 'Ver todas',
            onAction: () => context.go(AppRoutes.sessions),
          ),
          const SizedBox(height: 12),
          for (final (i, s) in mockSessoes.take(3).indexed) ...[
            SessionCard(
              filmeTitulo: s.filme,
              posterUrl: s.poster,
              sala: s.sala,
              data: s.data,
              horario: s.horario,
              formato: s.formato,
              vendidos: s.vendidos,
              capacidade: s.capacidade,
              onTap: () => context.push(AppRoutes.sessionDetail('$i')),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
