import 'package:flutter/material.dart';
import '../../mocks/mock_data.dart';
import '../../widgets/widgets.dart';

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
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Olá, Fulano!',
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                  onTap: () {},
                ),
              ),
              Expanded(
                child: StatCard(
                  icon: Icons.meeting_room_outlined,
                  value: '${mockSalas.length}',
                  label: 'Salas',
                  onTap: () {},
                ),
              ),
              Expanded(
                child: StatCard(
                  icon: Icons.event_outlined,
                  value: '${mockSessoes.length}',
                  label: 'Sessões',
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionTitle(
            title: 'Próximas sessões',
            actionLabel: 'Ver todas',
            onAction: () {},
          ),
          const SizedBox(height: 12),
          for (final s in mockSessoes.take(3)) ...[
            SessionCard(
              filmeTitulo: s.filme,
              posterUrl: s.poster,
              sala: s.sala,
              data: s.data,
              horario: s.horario,
              formato: s.formato,
              vendidos: s.vendidos,
              capacidade: s.capacidade,
              onTap: () {},
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
