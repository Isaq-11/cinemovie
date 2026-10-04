import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../models/sala.dart';
import '../../services/repositories.dart';
import '../../widgets/widgets.dart';

class TheatersScreen extends StatelessWidget {
  const TheatersScreen({super.key});

  Future<void> _excluir(BuildContext context, Sala s) async {
    final ok = await confirmDelete(context, itemName: s.nome);
    if (!ok) return;
    await SalaRepository.instance.delete(s.id);
    if (context.mounted) showAppSnackBar(context, 'Sala excluída.');
  }

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
            child: DataStream<List<Sala>>(
              stream: SalaRepository.instance.watchAll(),
              builder: (context, salas) => ItemList<Sala>(
                items: salas,
                empty: EmptyState(
                  icon: Icons.meeting_room_outlined,
                  title: 'Nenhuma sala cadastrada',
                  message: 'Cadastre uma sala para poder criar sessões.',
                  actionLabel: 'Cadastrar sala',
                  onAction: () => context.push(AppRoutes.theaterNew),
                ),
                itemBuilder: (context, s, _) {
                  final cores = Theme.of(context).colorScheme;
                  return InfoCard(
                    title: s.nome,
                    subtitle: 'Sala ${s.tipo}',
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: cores.primaryContainer,
                      child: Icon(Icons.meeting_room_outlined, color: cores.onPrimaryContainer),
                    ),
                    chips: [
                      InfoChip(label: '${s.capacidade} assentos', icon: Icons.event_seat_outlined),
                      if (s.acessivel) const InfoChip(label: 'Acessível', icon: Icons.accessible),
                      if (!s.ativa) InfoChip(label: 'Inativa', icon: Icons.block, color: cores.error),
                    ],
                    trailing: ItemActionsMenu(
                      onEdit: () => context.push(AppRoutes.theaterEdit(s.id)),
                      onDelete: () => _excluir(context, s),
                    ),
                    onTap: () => context.push(AppRoutes.theaterEdit(s.id)),
                  );
                },
              ),
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
