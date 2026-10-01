import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../mocks/mock_data.dart';
import '../../widgets/widgets.dart';

class TheatersScreen extends StatelessWidget {
  const TheatersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchBar(
              hint: 'Buscar sala cadastrada...',
              onSearch: () {},
              onChanged: (_) {},
            ),
          ),
          Expanded(
            child: ItemList<SalaMock>(
              items: mockSalas,
              empty: EmptyState(
                icon: Icons.meeting_room_outlined,
                title: 'Nenhuma sala cadastrada',
                message:
                    'Cadastre sua primeira sala para receber as futuras sessões.',
                actionLabel: 'Cadastrar sala',
                onAction: () => context.push(AppRoutes.theaterNew),
              ),
              itemBuilder: (context, s, i) {
                final cores = Theme.of(context).colorScheme;
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
                      icon: Icons.category_outlined,
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
                  trailing: ItemActionsMenu(
                    onEdit: () => context.push(AppRoutes.theaterEdit('$i')),
                    onDelete: () async {
                      final ok = await confirmDelete(context, itemName: s.nome);
                      if (ok && context.mounted) {
                        showAppSnackBar(context, 'Sala excluída.');
                      }
                    },
                  ),
                  onTap: () => context.push(AppRoutes.theaterEdit('$i')),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nova sala'),
        onPressed: () => context.push(AppRoutes.theaterNew),
      ),
    );
  }
}
