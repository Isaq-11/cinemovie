import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/app_routes.dart';
import '../../models/sala.dart';
import '../../services/repositories.dart';
import '../../widgets/widgets.dart';

class TheatersScreen extends StatefulWidget {
  const TheatersScreen({super.key});

  @override
  State<TheatersScreen> createState() => _TheatersScreenState();
}

class _TheatersScreenState extends State<TheatersScreen> {
  String _busca = '';

  List<Sala> _filtrarSalas(List<Sala> salas) {
    final busca = _busca.trim().toLowerCase();

    if (busca.isEmpty) return salas;

    return salas.where((sala) {
      return sala.nome.toLowerCase().contains(busca) ||
          sala.tipo.toLowerCase().contains(busca);
    }).toList();
  }

  Future<void> _excluir(BuildContext context, Sala s) async {
    final ok = await confirmDelete(context, itemName: s.nome);
    if (!ok) return;

    await SalaRepository.instance.delete(s.id);

    if (context.mounted) {
      showAppSnackBar(context, 'Sala excluída.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: const Text('Salas'),
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchBar(
              hint: 'Buscar sala cadastrada...',
              onSearch: () {},
              onChanged: (valor) {
                setState(() {
                  _busca = valor;
                });
              },
            ),
          ),
          Expanded(
            child: DataStream<List<Sala>>(
              stream: SalaRepository.instance.watchAll(),
              builder: (context, salas) {
                final salasFiltradas = _filtrarSalas(salas);

                return ItemList<Sala>(
                  items: salasFiltradas,
                  empty: EmptyState(
                    icon: Icons.meeting_room_outlined,
                    title: _busca.isEmpty
                        ? 'Nenhuma sala cadastrada'
                        : 'Nenhuma sala encontrada',
                    message: _busca.isEmpty
                        ? 'Cadastre uma sala para poder criar sessões.'
                        : 'Nenhuma sala corresponde à busca.',
                    actionLabel: _busca.isEmpty ? 'Cadastrar sala' : null,
                    onAction: _busca.isEmpty
                        ? () => context.push(AppRoutes.theaterNew)
                        : null,
                  ),
                  itemBuilder: (context, s, _) {
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
                      trailing: ItemActionsMenu(
                        onEdit: () => context.push(AppRoutes.theaterEdit(s.id)),
                        onDelete: () => _excluir(context, s),
                      ),
                      onTap: () => context.push(AppRoutes.theaterEdit(s.id)),
                    );
                  },
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
