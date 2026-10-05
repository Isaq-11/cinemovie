import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/sessao.dart';
import '../../router/app_routes.dart';
import '../../services/repositories.dart';
import '../../utils/formatters.dart';
import '../../widgets/widgets.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({super.key, required this.id});
  final String id;

  Future<void> _vender(Sessao s, int qtd) {
    final novo = (s.vendidos + qtd).clamp(0, s.capacidade).toInt();
    return SessaoRepository.instance.setVendidos(s.id, novo);
  }

  Future<void> _cancelarIngresso(Sessao s, int qtd) async {
    if (qtd <= 0) return;
    if (qtd > s.vendidos) return;

    final novo = s.vendidos - qtd;

    await SessaoRepository.instance.setVendidos(s.id, novo);
  }

  Future<void> _excluir(BuildContext context) async {
    final ok = await confirmDelete(context, itemName: 'esta sessão');
    if (!ok) return;
    await SessaoRepository.instance.delete(id);
    if (context.mounted) {
      showAppSnackBar(context, 'Sessão excluída.');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da sessão')),
      body: DataStream<Sessao?>(
        stream: SessaoRepository.instance.watchById(id),
        builder: (context, s) {
          if (s == null) {
            return EmptyState(
              icon: Icons.event_busy_outlined,
              title: 'Sessão não encontrada',
              message: 'Ela pode ter sido removida.',
              actionLabel: 'Ver sessões',
              onAction: () => context.go(AppRoutes.sessions),
            );
          }
          return SafeArea(
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
                        current: s.vendidos,
                        total: s.capacidade,
                        height: 14,
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          for (final q in [1, 5, 10])
                            Expanded(
                              child: AppButton(
                                label: '+$q',
                                variant: AppButtonVariant.outlined,
                                onPressed: () => _vender(s, q),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          for (final q in [1, 5, 10])
                            Expanded(
                              child: AppButton(
                                label: '-$q',
                                variant: AppButtonVariant.outlined,
                                onPressed: () => _cancelarIngresso(s, q),
                              ),
                            ),
                        ],
                      ),
                      AppButton(
                        label: 'Zerar lotação',
                        icon: Icons.restart_alt,
                        variant: AppButtonVariant.text,
                        onPressed: () =>
                            SessaoRepository.instance.setVendidos(s.id, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FormActionBar(
        primaryLabel: 'Editar sessão',
        primaryIcon: Icons.edit_outlined,
        onPrimary: () => context.push(AppRoutes.sessionEdit(id)),
        secondaryLabel: 'Excluir',
        onSecondary: () => _excluir(context),
      ),
    );
  }
}
