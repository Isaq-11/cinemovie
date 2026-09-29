import 'package:flutter/material.dart';
import '../../mocks/mock_data.dart';
import '../../widgets/widgets.dart';

class MoviesScreen extends StatelessWidget {
  const MoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filmes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchBar(
              hint: 'Buscar filme cadastrado...',
              onSearch: () {},
              onChanged: (_) {},
            ),
          ),
          Expanded(
            child:
                mockFilmes
                    .isEmpty // troque por [] para ver o EmptyState
                ? EmptyState(
                    icon: Icons.movie_outlined,
                    title: 'Nenhum filme cadastrado',
                    message: 'Cadastre seu primeiro filme para criar sessões.',
                    actionLabel: 'Cadastrar filme',
                    onAction: () {},
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                    itemCount: mockFilmes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final f = mockFilmes[i];
                      return InfoCard(
                        title: f.titulo,
                        subtitle: '${f.duracao} min',
                        leading: PosterPreview(imageUrl: f.poster, width: 64),
                        chips: [
                          InfoChip(
                            label: f.genero,
                            icon: Icons.category_outlined,
                          ),
                          InfoChip(
                            label: 'Class. ${f.classificacao}',
                            icon: Icons.shield_outlined,
                          ),
                        ],
                        trailing: ItemActionsMenu(
                          onEdit: () {},
                          onDelete: () async {
                            final ok = await showConfirmDialog(
                              context,
                              title: 'Excluir filme?',
                              message:
                                  '"${f.titulo}" será removido do catálogo.',
                              confirmLabel: 'Excluir',
                              isDestructive: true,
                            );
                            if (ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Filme excluído.'),
                                ),
                              );
                            }
                          },
                        ),
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
        label: const Text('Novo filme'),
      ),
    );
  }
}
