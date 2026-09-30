import 'package:cine_movie/constants/app_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../utils/formatters.dart';
import '../../utils/validators.dart';

class SessionFormScreen extends StatefulWidget {
  const SessionFormScreen({super.key, this.id});

  final String? id;

  @override
  State<SessionFormScreen> createState() => _SessionFormScreenState();
}

class _SessionFormScreenState extends State<SessionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _filmeBuscaCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _horarioCtrl = TextEditingController();

  String? _filmeId;
  String? _filmeTitulo;
  String? _filmePosterUrl;

  String? _sala;
  String? _idioma = 'Dublado';
  String? _formato = '2D';

  DateTime? _data;
  TimeOfDay? _horario;

  static const _salas = ['Sala 1', 'Sala 2', 'Sala 3', 'Sala 4', 'Sala 5'];

  @override
  void dispose() {
    _filmeBuscaCtrl.dispose();
    _precoCtrl.dispose();
    _dataCtrl.dispose();
    _horarioCtrl.dispose();
    super.dispose();
  }

  String? _validarFilme(String? _) {
    if (_filmeId == null) {
      return 'Selecione um filme';
    }
    return null;
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();

    final selecionada = await showDatePicker(
      context: context,
      helpText: 'Escolha o dia de exibição',
      cancelText: 'Cancelar',
      initialDate: _data ?? hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 1),
    );

    if (selecionada == null) return;

    setState(() {
      _data = selecionada;
      _dataCtrl.text = Formatters.data(selecionada);
    });
  }

  Future<void> _selecionarHorario() async {
    final selecionado = await showTimePicker(
      context: context,
      helpText: 'Escolha o horário de exibição',
      cancelText: 'Cancelar',
      initialTime: _horario ?? TimeOfDay.now(),
    );

    if (selecionado == null) return;

    setState(() {
      _horario = selecionado;
      _horarioCtrl.text = selecionado.format(context);
    });
  }

  void _buscarFilme() {
    final busca = _filmeBuscaCtrl.text.trim();

    if (busca.isEmpty) {
      return;
    }

    // TODO:
    // Buscar filmes na API/TMDB.
    //
    // Depois que o usuário escolher um filme:
    //
    // setState(() {
    //   _filmeId = filme.id;
    //   _filmeTitulo = filme.titulo;
    //   _filmePosterUrl = filme.posterUrl;
    // });
  }

  void _removerFilme() {
    setState(() {
      _filmeId = null;
      _filmeTitulo = null;
      _filmePosterUrl = null;
      _filmeBuscaCtrl.clear();
    });
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    // TODO (Firebase): salvar sessão
    showAppSnackBar(context, 'Sessão salva!');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: widget.id == null ? 'Nova sessão' : 'Editar sessão',
      formKey: _formKey,
      primaryLabel: 'Salvar sessão',
      primaryIcon: Icons.check,
      onPrimary: _salvar,
      children: [
        FormSection(
          title: 'Filme',
          icon: Icons.movie_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              AppSearchBar(
                controller: _filmeBuscaCtrl,
                hint: 'Buscar filme...',
                onSearch: _buscarFilme,
              ),
              if (_filmeId != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PosterPreview(imageUrl: _filmePosterUrl, width: 90),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _filmeTitulo ?? '',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _removerFilme,
                            icon: const Icon(Icons.close),
                            label: const Text('Trocar filme'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              FormField<String>(
                validator: _validarFilme,
                builder: (field) {
                  return field.hasError
                      ? Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FormSection(
          title: 'Exibição',
          icon: Icons.theaters_outlined,
          child: Column(
            spacing: 16,
            children: [
              AppDropdownField<String>(
                label: 'Sala',
                prefixIcon: Icons.meeting_room_outlined,
                items: _salas,
                value: _sala,
                itemLabel: (s) => s,
                onChanged: (v) => setState(() => _sala = v),
                validator: (v) => v == null ? 'Selecione a sala' : null,
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: TextEditingController(
                        text: _data == null ? '' : Formatters.data(_data!),
                      ),
                      label: 'Data',
                      prefixIcon: Icons.calendar_today_outlined,
                      hint: 'Selecione...',
                      enabled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: _selecionarData,
                      ),
                      validator: (_) => _data == null ? 'Informe a data' : null,
                    ),
                  ),
                  Expanded(
                    child: AppTextField(
                      controller: TextEditingController(
                        text: _horario == null ? '' : _horario!.format(context),
                      ),
                      label: 'Horário',
                      prefixIcon: Icons.schedule,
                      hint: 'Selecione...',
                      enabled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: _selecionarHorario,
                      ),
                      validator: (_) =>
                          _horario == null ? 'Informe o horário' : null,
                    ),
                  ),
                ],
              ),
              AppTextField(
                controller: _precoCtrl,
                label: 'Preço do ingresso',
                hint: 'Ex.: 35',
                prefixIcon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
                validator: Validators.preco,
              ),
              ChoiceChipGroup(
                label: 'Idioma',
                options: AppOptions.idiomas,
                selected: _idioma ?? 'Dublado',
                onSelected: (v) => setState(() => _idioma = v),
              ),
              ChoiceChipGroup(
                label: 'Formato de exibição',
                options: AppOptions.formatos,
                selected: _formato ?? '2D',
                onSelected: (v) => setState(() => _formato = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
