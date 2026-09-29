import 'package:flutter/material.dart';
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
    final sessoes = _filtro == 'Todas'
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
            child: sessoes.isEmpty
                ? EmptyState(
                    icon: Icons.event_busy_outlined,
                    title: 'Nenhuma sessão',
                    message: 'Não há sessões para o filtro escolhido.',
                    actionLabel: 'Nova sessão',
                    onAction: () {},
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: sessoes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final s = sessoes[i];
                      return SessionCard(
                        filmeTitulo: s.filme,
                        posterUrl: s.poster,
                        sala: s.sala,
                        data: s.data,
                        horario: s.horario,
                        formato: s.formato,
                        vendidos: s.vendidos,
                        capacidade: s.capacidade,
                        onTap: () {},
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nova sessão'),
      ),
    );
  }
}
