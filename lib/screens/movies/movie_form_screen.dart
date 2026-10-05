import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../services/tmdb_service.dart';
import '../../models/filme.dart';
import '../../services/repositories.dart';
import '../../utils/validators.dart';
import '../../constants/app_options.dart';

class MovieFormScreen extends StatefulWidget {
  const MovieFormScreen({super.key, this.id});
  final String? id;

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buscaCtrl = TextEditingController();
  final _tituloCtrl = TextEditingController();
  final _sinopseCtrl = TextEditingController();
  final _duracaoCtrl = TextEditingController();

  String? _genero;
  String? _classificacao = 'L';

  String? _poster;
  bool _buscando = false;
  bool _salvando = false;
  bool _carregandoDados = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _carregandoDados = true;
      _carregar();
    }
  }

  Future<void> _carregar() async {
    final f = await FilmeRepository.instance.getById(widget.id!);
    if (!mounted) return;
    if (f == null) {
      showAppSnackBar(context, 'Filme não encontrado.', isError: true);
      context.pop();
      return;
    }
    setState(() {
      _tituloCtrl.text = f.titulo;
      _sinopseCtrl.text = f.sinopse;
      _duracaoCtrl.text = '${f.duracao}';
      _genero = f.genero;
      _classificacao = f.classificacao;
      _poster = f.poster;
      _carregandoDados = false;
    });
  }

  Future<void> _buscarTmdb() async {
    final termo = _buscaCtrl.text.trim();
    if (termo.isEmpty) return;
    setState(() => _buscando = true);
    try {
      final resultados = await TmdbService.buscar(termo);
      if (!mounted) return;
      if (resultados.isEmpty) {
        showAppSnackBar(context, 'Nenhum filme encontrado.');
        return;
      }

      final escolhido = await showModalBottomSheet<TmdbMovie>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (ctx) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (ctx, scroll) => ListView.builder(
            controller: scroll,
            itemCount: resultados.length,
            itemBuilder: (ctx, i) {
              final m = resultados[i];
              return ListTile(
                leading: PosterPreview(imageUrl: m.poster, width: 40),
                title: Text(m.titulo),
                subtitle: Text(m.ano ?? ''),
                onTap: () => Navigator.of(ctx).pop(m),
              );
            },
          ),
        ),
      );
      if (escolhido == null) return;

      final duracao = await TmdbService.duracao(escolhido.id);
      if (!mounted) return;
      setState(() {
        _tituloCtrl.text = escolhido.titulo;
        _sinopseCtrl.text = escolhido.sinopse;
        _poster = escolhido.poster;
        if (duracao != null) _duracaoCtrl.text = '$duracao';
        if (escolhido.genero != null) _genero = escolhido.genero;
      });
    } catch (e) {
      debugPrint('Erro TMDB: $e');
      if (mounted) {
        showAppSnackBar(
          context,
          'Não foi possível buscar no TMDB.',
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      await FilmeRepository.instance.save(
        Filme(
          titulo: _tituloCtrl.text.trim(),
          genero: _genero!,
          duracao: int.parse(_duracaoCtrl.text),
          classificacao: _classificacao ?? 'L',
          sinopse: _sinopseCtrl.text.trim(),
          poster: _poster,
        ),
        id: widget.id,
      );
      if (!mounted) return;
      showAppSnackBar(context, 'Filme salvo!');
      context.pop();
    } catch (e) {
      debugPrint('Erro ao salvar filme: $e');
      if (mounted)
        showAppSnackBar(
          context,
          'Erro ao salvar. Tente novamente.',
          isError: true,
        );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
    _carregar();
  }

  @override
  void dispose() {
    _buscaCtrl.dispose();
    _tituloCtrl.dispose();
    _sinopseCtrl.dispose();
    _duracaoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregandoDados) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return FormScaffold(
      title: widget.id == null ? 'Novo filme' : 'Editar filme',
      formKey: _formKey,
      primaryLabel: 'Salvar filme',
      primaryIcon: Icons.check,
      isLoading: _salvando,
      onPrimary: _salvar,
      children: [
        FormSection(
          title: 'Buscar no TMDB',
          icon: Icons.travel_explore,
          child: AppSearchBar(
            controller: _buscaCtrl,
            hint: 'Digite o título do filme',
            onSearch: _buscarTmdb,
            isLoading: _buscando,
          ),
        ),
        FormSection(
          title: 'Informações do filme',
          icon: Icons.movie_outlined,
          child: Column(
            spacing: 16,
            children: [
              PosterPreview(imageUrl: _poster, width: 140),
              AppTextField(
                controller: _tituloCtrl,
                label: 'Título',
                hint: 'Ex.: Clube da Luta',
                prefixIcon: Icons.title,
                textInputAction: TextInputAction.next,
                validator: Validators.obrigatorio('Informe o título'),
              ),
              AppTextField(
                controller: _sinopseCtrl,
                label: 'Sinopse',
                prefixIcon: Icons.notes,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
              ),
              AppTextField(
                controller: _duracaoCtrl,
                label: 'Duração',
                prefixIcon: Icons.schedule,
                suffixText: 'min',
                keyboardType: TextInputType.number,
                validator: Validators.inteiroPositivo,
              ),
              AppDropdownField<String>(
                label: 'Gênero',
                prefixIcon: Icons.category_outlined,
                items: AppOptions.generos,
                value: _genero,
                itemLabel: (g) => g,
                onChanged: (v) => setState(() => _genero = v),
                validator: (v) => v == null ? 'Selecione um gênero' : null,
              ),
              ChoiceChipGroup(
                label: 'Classificação indicativa',
                options: AppOptions.classificacoes,
                selected: _classificacao,
                onSelected: (v) => setState(() => _classificacao = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
