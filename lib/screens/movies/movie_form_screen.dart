import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
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

  @override
  void dispose() {
    _buscaCtrl.dispose();
    _tituloCtrl.dispose();
    _sinopseCtrl.dispose();
    _duracaoCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    // TODO (Firebase): salvar filme
    showAppSnackBar(context, 'Filme salvo!');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: widget.id == null ? 'Novo filme' : 'Editar filme', 
      formKey: _formKey, 
      primaryLabel: 'Salvar filme', 
      primaryIcon: Icons.check,
      onPrimary: _salvar,
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
        FormSection(
          title: 'Informações do filme',
          icon: Icons.movie_outlined,
          child: Column(
            spacing: 16,
            children: [
              const PosterPreview(imageUrl: null, width: 140),
              AppTextField(
                controller: _tituloCtrl,
                label: 'Título',
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
                validator: Validators.inteiroPositivo, // 👈 Simplificado para usar a referência direta
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
                onSelected: (v) => setState(() => _classificacao), 
              ),
            ],
          ),
        ),
      ], 
    );
  }
}
