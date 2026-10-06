import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../widgets/widgets.dart';
import '../../services/repositories.dart';
import '../../models/sessao.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  static const _filtros = ['Todas', 'Hoje', 'Amanhã'];
  String _filtro = 'Todas';

  final _stream = SessaoRepository.instance.watchAll();

  Future<void> _excluir(Sessao s) async {
    final ok = await confirmDelete(context, itemName: 'Sessão de ${s.filme}');
    if (!ok) return;
    await SessaoRepository.instance.delete(s.id);
    if (mounted) showAppSnackBar(context, 'Sessão excluída.');
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
        title: const Text('Sessões'),
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
            child: DataStream<List<Sessao>>(
              stream: _stream,
              builder: (context, todas) {
                final sessoes = _filtro == 'Todas'
                    ? todas
                    : todas.where((s) => s.data == _filtro).toList();

                return ItemList<Sessao>(
                  items: sessoes,
                  empty: EmptyState(
                    icon: Icons.event_busy_outlined,
                    title: 'Nenhuma sessão encontrada',
                    message: 'Não há sessões programadas para este filtro.',
                    actionLabel: 'Nova sessão',
                    onAction: () => context.push(AppRoutes.sessionNew),
                  ),
                  itemBuilder: (context, s, _) => SessionCard(
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
                    trailing: ItemActionsMenu(
                      onEdit: () => context.push(AppRoutes.sessionEdit(s.id)),
                      onDelete: () => _excluir(s),
                    ),
                    onTap: () => context.push(AppRoutes.sessionDetail(s.id)),
                  ),
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
