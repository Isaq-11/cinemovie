import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_routes.dart';
import '../../widgets/widgets.dart';
import '../../models/filme.dart';
import '../../services/repositories.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});
  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _stream = FilmeRepository.instance.watchAll();
  String _busca = '';

  Future<void> _excluir(Filme f) async {
    final ok = await confirmDelete(context, itemName: f.titulo);
    if (!ok) return;
    await FilmeRepository.instance.delete(f.id);
    if (mounted) showAppSnackBar(context, 'Filme excluído.');
  }

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
              onChanged: (v) => setState(() => _busca = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: DataStream<List<Filme>>(
              stream: _stream,
              builder: (context, todos) {
                final filmes = todos
                    .where((f) => f.titulo.toLowerCase().contains(_busca))
                    .toList();
                return ItemList<Filme>(
                  items: filmes,
                  empty: EmptyState(
                    icon: Icons.movie_outlined,
                    title: _busca.isEmpty ? 'Nenhum filme cadastrado' : 'Nada encontrado',
                    message: _busca.isEmpty
                        ? 'Cadastre seu primeiro filme para criar sessões.'
                        : 'Nenhum filme combina com a busca.',
                    actionLabel: _busca.isEmpty ? 'Cadastrar filme' : null,
                    onAction: () => context.push(AppRoutes.movieNew),
                  ),
                  itemBuilder: (context, f, _) => InfoCard(
                    title: f.titulo,
                    subtitle: '${f.duracao} min',
                    leading: PosterPreview(imageUrl: f.poster, width: 64),
                    chips: [
                      InfoChip(label: f.genero, icon: Icons.category_outlined),
                      InfoChip(label: 'Class. ${f.classificacao}', icon: Icons.shield_outlined),
                    ],
                    trailing: ItemActionsMenu(
                      onEdit: () => context.push(AppRoutes.movieEdit(f.id)),
                      onDelete: () => _excluir(f),
                    ),
                    onTap: () => context.push(AppRoutes.movieEdit(f.id)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.movieNew),
        icon: const Icon(Icons.add),
        label: const Text('Novo filme'),
      ),
    );
  }
}