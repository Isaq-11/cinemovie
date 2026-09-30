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
              hint: 'Buscar sala cadastrado...',
              onSearch: () {},
              onChanged: (_) {},
            ),
          ),
          Expanded(
            child: ItemList<SalaMock>(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 96),
              items: mockSalas, 
              empty: EmptyState(
                icon: Icons.movie_outlined, 
                title: 'Nenhuma sala cadastrada', 
                message: 'Cadastre sua primeira sala para receber as futuras sessões.',
                actionLabel: 'Cadastrar sala',
                onAction: () => context.push(AppRoutes.theaterNew),
              ),
              itemBuilder: (context, s, i) {
                return InfoCard(
                  title: s.nome,
                  subtitle: 'Sala ${s.tipo}',
                  leading: CircleAvatar(
                     radius: 26,
                     //backgroundColor: .primaryContainer,
                     child: Icon(
                       Icons.meeting_room_outlined,
                       color: Colors.grey,
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
                        color: Colors.red,
                    ),                 
                  ],
                  trailing: ItemActionsMenu(
                    onEdit: () => context.push(AppRoutes.theaterEdit('$i')), 
                    onDelete: () async {
                      final ok = await confirmDelete(context, itemName: s.nome);
                      if (ok && context.mounted) showAppSnackBar(context, 'Sala excluída.');
                    },
                  ),
                  onTap: () => context.push(AppRoutes.theaterEdit('$i')),
                );
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nova sala'),
      ),
    );
  }
}