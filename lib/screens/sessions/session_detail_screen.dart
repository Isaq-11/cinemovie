import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../mocks/mock_data.dart';
import '../../router/app_routes.dart';
import '../../widgets/widgets.dart';
import '../../utils/formatters.dart';

class SessionDetailScreen extends StatefulWidget {
  const SessionDetailScreen({super.key, required this.id});
  final String id;

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  SessaoMock? _s;
  int _vendidos = 0;

  @override
  void initState() {
    super.initState();
    // TODO (Firebase): buscar pelo id do documento
    final i = int.tryParse(widget.id);
    if (i != null && i >= 0 && i < mockSessoes.length) {
      _s = mockSessoes[i];
      _vendidos = _s!.vendidos;
    }
  }

  void _vender(int qtd) =>
      setState(() => _vendidos = (_vendidos + qtd).clamp(0, _s!.capacidade));

  Future<void> _excluir() async {
    final ok = await confirmDelete(context, itemName: _s!.filme);
    if (!ok || !mounted) return;
    showAppSnackBar(context, 'Sessão excluída.');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    final tema = Theme.of(context);

    if (s == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sessão')),
        body: EmptyState(
          icon: Icons.event_busy_outlined,
          title: 'Sessão não encontrada',
          message: 'Ela pode ter sido removida.',
          actionLabel: 'Ver sessões',
          onAction: () => context.go(AppRoutes.sessions),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da sessão')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PosterPreview(imageUrl: s.poster, width: 100),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.filme,
                        style: tema.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          InfoChip(
                            label: s.formato,
                            icon: Icons.movie_filter_outlined,
                          ),
                          InfoChip(label: s.idioma, icon: Icons.translate),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FormSection(
              title: 'Informações',
              icon: Icons.info_outline,
              child: Column(
                spacing: 12,
                children: [
                  InfoRow(
                    icon: Icons.meeting_room_outlined,
                    label: 'Sala',
                    value: s.sala,
                  ),
                  InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Data',
                    value: s.data,
                  ),
                  InfoRow(
                    icon: Icons.schedule,
                    label: 'Horário',
                    value: s.horario,
                  ),
                  InfoRow(
                    icon: Icons.payments_outlined,
                    label: 'Preço',
                    value: Formatters.moeda(s.preco),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FormSection(
              title: 'Lotação',
              icon: Icons.event_seat_outlined,
              child: Column(
                spacing: 16,
                children: [
                  OccupancyBar(
                    current: _vendidos,
                    total: s.capacidade,
                    height: 14,
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: AppButton(
                          label: '+1',
                          variant: AppButtonVariant.outlined,
                          onPressed: () => _vender(1),
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          label: '+5',
                          variant: AppButtonVariant.outlined,
                          onPressed: () => _vender(5),
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          label: '+10',
                          variant: AppButtonVariant.outlined,
                          onPressed: () => _vender(10),
                        ),
                      ),
                    ],
                  ),
                  AppButton(
                    label: 'Zerar lotação',
                    icon: Icons.restart_alt,
                    variant: AppButtonVariant.text,
                    onPressed: () => setState(() => _vendidos = 0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FormActionBar(
        primaryLabel: 'Editar sessão',
        primaryIcon: Icons.edit_outlined,
        onPrimary: () => context.push(AppRoutes.sessionEdit(widget.id)),
        secondaryLabel: 'Excluir',
        onSecondary: _excluir,
      ),
    );
  }
}
