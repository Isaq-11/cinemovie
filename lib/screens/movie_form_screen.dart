import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class FilmeFormScreen extends StatefulWidget {
  const FilmeFormScreen({super.key, this.id});
  final String? id; // null = novo filme; preenchido = edição (futuro)

  @override
  State<FilmeFormScreen> createState() => _FilmeFormScreenState();
}

class _FilmeFormScreenState extends State<FilmeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buscaCtrl = TextEditingController();
  final _tituloCtrl = TextEditingController();
  final _sinopseCtrl = TextEditingController();
  final _duracaoCtrl = TextEditingController();

  String? _genero;
  String? _classificacao;

  static const _generos = [
    'Ação', 'Animação', 'Aventura', 'Comédia', 'Documentário',
    'Drama', 'Ficção científica', 'Romance', 'Terror',
  ];
  static const _classificacoes = ['L', '10', '12', '14', '16', '18'];

  @override
  void dispose() {
    _buscaCtrl.dispose();
    _tituloCtrl.dispose();
    _sinopseCtrl.dispose();
    _duracaoCtrl.dispose();
    super.dispose();
  }

  String? _obrigatorio(String? v, String msg) =>
      (v == null || v.trim().isEmpty) ? msg : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Novo filme' : 'Editar filme'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FormSection(
                title: 'Buscar no TMDB',
                icon: Icons.travel_explore,
                child: AppSearchBar(
                  controller: _buscaCtrl,
                  hint: 'Digite o título do filme',
                  onSearch: () {}, // lógica virá depois
                ),
              ),
              const SizedBox(height: 16),
              FormSection(
                title: 'Informações do filme',
                icon: Icons.movie_outlined,
                child: Column(
                  spacing: 16, // Flutter 3.27+; senão, use SizedBox
                  children: [
                    const PosterPreview(imageUrl: null, width: 140),
                    AppTextField(
                      controller: _tituloCtrl,
                      label: 'Título',
                      prefixIcon: Icons.title,
                      textInputAction: TextInputAction.next,
                      validator: (v) => _obrigatorio(v, 'Informe o título'),
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
                      validator: (v) => _obrigatorio(v, 'Informe a duração'),
                    ),
                    AppDropdownField<String>(
                      label: 'Gênero',
                      prefixIcon: Icons.category_outlined,
                      items: _generos,
                      value: _genero,
                      itemLabel: (g) => g,
                      onChanged: (v) => setState(() => _genero = v),
                      validator: (v) => v == null ? 'Selecione um gênero' : null,
                    ),
                    ChoiceChipGroup(
                      label: 'Classificação indicativa',
                      options: _classificacoes,
                      selected: _classificacao,
                      onSelected: (v) => setState(() => _classificacao = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FormActionBar(
        primaryLabel: 'Salvar filme',
        primaryIcon: Icons.check,
        onPrimary: () => _formKey.currentState!.validate(),
        secondaryLabel: 'Cancelar',
        onSecondary: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}