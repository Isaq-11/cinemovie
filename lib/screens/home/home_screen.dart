import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../widgets/widgets.dart';
import '../../services/auth_service.dart';
import '../../services/repositories.dart';
import '../../models/sessao.dart';

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
                child: StreamBuilder<int>(
                  stream: FilmeRepository.instance.watchCount(),
                  initialData: 0,
                  builder: (_, s) => StatCard(
                    icon: Icons.movie_outlined,
                    value: '${s.data}',
                    label: 'Filmes',
                    onTap: () => context.go(AppRoutes.movies),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<int>(
                  stream: SalaRepository.instance.watchCount(),
                  initialData: 0,
                  builder: (_, s) => StatCard(
                    icon: Icons.meeting_room_outlined,
                    value: '${s.data}',
                    label: 'Salas',
                    onTap: () => context.go(AppRoutes.theaters),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<int>(
                  stream: SessaoRepository.instance.watchCount(),
                  initialData: 0,
                  builder: (_, s) => StatCard(
                    icon: Icons.event_outlined,
                    value: '${s.data}',
                    label: 'Sessões',
                    onTap: () => context.go(AppRoutes.sessions),
                  ),
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
          DataStream<List<Sessao>>(
            stream: SessaoRepository.instance.watchAll(),
            builder: (context, todas) {
              final agora = DateTime.now();
              final proximas = todas
                  .where((s) => s.inicio.isAfter(agora))
                  .take(3)
                  .toList();
              if (proximas.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('Nenhuma sessão agendada.')),
                );
              }
              return Column(
                spacing: 12,
                children: [
                  for (final s in proximas)
                    SessionCard(
                      filmeTitulo: s.filme,
                      posterUrl: s.poster,
                      sala: s.sala,
                      data: s.data,
                      horario: s.horario,
                      formato: s.formato,
                      idioma: s.idioma,
                      vendidos: s.vendidos,
                      capacidade: s.capacidade,
                      duracao: s.duracao,
                      onTap: () => context.push(AppRoutes.sessionDetail(s.id)),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
