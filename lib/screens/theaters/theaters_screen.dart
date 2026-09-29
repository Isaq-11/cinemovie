import 'package:flutter/material.dart';
import '../../mocks/mock_data.dart';
import '../../widgets/widgets.dart';

class TheatersScreen extends StatelessWidget {
  const TheatersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Salas')),
      body: mockSalas.isEmpty
          ? EmptyState(
              icon: Icons.meeting_room_outlined,
              title: 'Nenhuma sala cadastrada',
              message: 'Cadastre uma sala para poder criar sessões.',
              actionLabel: 'Cadastrar sala',
              onAction: () {},
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: mockSalas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final s = mockSalas[i];
                return InfoCard(
                  title: s.nome,
                  subtitle: 'Sala ${s.tipo}',
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: cores.primaryContainer,
                    child: Icon(
                      Icons.meeting_room_outlined,
                      color: cores.onPrimaryContainer,
                    ),
                  ),
                  chips: [
                    InfoChip(
                      label: '${s.capacidade} assentos',
                      icon: Icons.event_seat_outlined,
                    ),
                    if (s.acessivel)
                      const InfoChip(
                        label: 'Acessível',
                        icon: Icons.accessible,
                      ),
                    if (!s.ativa)
                      InfoChip(
                        label: 'Inativa',
                        icon: Icons.block,
                        color: cores.error,
                      ),
                  ],
                  trailing: ItemActionsMenu(onEdit: () {}, onDelete: () {}),
                  onTap: () {},
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nova sala'),
      ),
    );
  }
}
