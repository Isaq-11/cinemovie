import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
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
            child: ItemList<FilmeMock>(
              items: mockFilmes,
              empty: EmptyState(
                icon: Icons.movie_outlined,
                title: 'Nenhum filme cadastrado',
                message: 'Cadastre seu primeiro filme para criar sessões.',
                actionLabel: 'Cadastrar filme',
                onAction: () => context.push(AppRoutes.movieNew),
              ),
              itemBuilder: (context, f, i) {
                return InfoCard(
                  title: f.titulo,
                  subtitle: '${f.duracao} min',
                  leading: PosterPreview(imageUrl: f.poster, width: 64),
                  chips: [
                    InfoChip(label: f.genero, icon: Icons.category_outlined),
                    InfoChip(
                      label: 'Class. ${f.classificacao}',
                      icon: Icons.shield_outlined,
                    ),
                  ],
                  trailing: ItemActionsMenu(
                    onEdit: () => context.push(AppRoutes.movieEdit('$i')),
                    onDelete: () async {
                      final ok = await confirmDelete(
                        context,
                        itemName: f.titulo,
                      );
                      if (ok && context.mounted) {
                        showAppSnackBar(context, 'Filme excluído.');
                      }
                      ;
                    },
                  ),
                  onTap: () => context.push(AppRoutes.movieEdit('$i')),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Novo filme'),
        onPressed: () => context.push(AppRoutes.movieNew),
      ),
    );
  }
}
