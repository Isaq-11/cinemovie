import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../mocks/mock_data.dart';
import '../../widgets/widgets.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  static const _filtros = ['Todas', 'Hoje', 'Amanhã'];
  String _filtro = 'Todas';

  @override
  Widget build(BuildContext context) {
    final sessoesFiltradas = _filtro == 'Todas'
        ? mockSessoes
        : mockSessoes.where((s) => s.data == _filtro).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Sessões')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ChoiceChipGroup(
                options: _filtros,
                selected: _filtro,
                onSelected: (v) => setState(() => _filtro = v),
              ),
            ),
          ),

          Expanded(
            child: ItemList<SessaoMock>(
              items: sessoesFiltradas,
              empty: EmptyState(
                icon: Icons.event_busy_outlined,
                title: 'Nenhuma sessão encontrada',
                message: 'Não há sessões programadas para este filtro.',
                actionLabel: 'Nova sessão',
                onAction: () => context.push(AppRoutes.sessionNew),
              ),
              itemBuilder: (context, s, i) {
                final indiceOriginal = mockSessoes.indexOf(s);
                return InfoCard(
                  title: s.filme,
                  subtitle: '${s.data} às ${s.horario}',
                  leading: PosterPreview(imageUrl: s.poster, width: 64),
                  chips: [
                    InfoChip(label: s.sala, icon: Icons.meeting_room_outlined),
                    InfoChip(label: s.formato, icon: Icons.theaters_outlined),
                    InfoChip(
                      label:
                          '${s.vendidos}/${s.capacidade} vendidos', // Ocupação da sala
                      icon: Icons.confirmation_number_outlined,
                    ),
                  ],
                  trailing: ItemActionsMenu(
                    onEdit: () => context.push(AppRoutes.sessionEdit('$i')),
                    onDelete: () async {
                      final ok = await confirmDelete(
                        context,
                        itemName: 'Sessão de ${s.filme}',
                      );
                      if (ok && context.mounted)
                        showAppSnackBar(context, 'Sessão excluída.');
                    },
                  ),
                  onTap: () =>
                      context.push(AppRoutes.sessionDetail('$indiceOriginal')),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.sessionNew),
        icon: const Icon(Icons.add),
        label: const Text('Nova sessão'),
      ),
    );
  }
}
