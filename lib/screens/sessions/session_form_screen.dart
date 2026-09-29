import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../router/app_routes.dart';

class SessionFormScreen extends StatefulWidget {
  const SessionFormScreen({super.key, this.id});

  final String? id; // null = nova sessão; preenchido = edição

  @override
  State<SessionFormScreen> createState() => _SessionFormScreenState();
}

class _SessionFormScreenState extends State<SessionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _filmeBuscaCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();

  String? _filmeId;
  String? _filmeTitulo;
  String? _filmePosterUrl;

  String? _sala;
  String? _idioma;
  String? _formato;

  DateTime? _data;
  TimeOfDay? _horario;

  static const _salas = ['Sala 1', 'Sala 2', 'Sala 3', 'Sala 4', 'Sala 5'];

  static const _idiomas = ['Dublado', 'Legendado', 'Original'];

  static const _formatos = ['2D', '3D', 'IMAX'];

  @override
  void dispose() {
    _filmeBuscaCtrl.dispose();
    _precoCtrl.dispose();
    super.dispose();
  }

  String? _obrigatorio(String? value, String message) {
    return value == null || value.trim().isEmpty ? message : null;
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
    });
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  String _formatarHorario(TimeOfDay horario) {
    final hora = horario.hour.toString().padLeft(2, '0');
    final minuto = horario.minute.toString().padLeft(2, '0');

    return '$hora:$minuto';
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
    if (!_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TheaterFormScreen()),
      );
    }

    if (_data == null || _horario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a data e o horário da sessão.')),
      );

      return;
    }

    // Aqui você teria os dados necessários para criar a sessão:
    //
    // _filmeId
    // _sala
    // _data
    // _horario
    // _idioma
    // _formato
    // _precoCtrl.text

    // TODO: salvar sessão.

    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Nova sessão' : 'Editar sessão'),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ------------------------------------------------------------
              // FILME
              // ------------------------------------------------------------
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

              // ------------------------------------------------------------
              // EXIBIÇÃO
              // ------------------------------------------------------------
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
                      itemLabel: (sala) => sala,
                      onChanged: (value) {
                        setState(() {
                          _sala = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione uma sala';
                        }

                        return null;
                      },
                    ),

                    AppPickerField(
                      label: 'Data',
                      hint: 'Selecione a data',
                      icon: Icons.calendar_today_outlined,
                      valueText: _data == null ? null : _formatarData(_data!),
                      onTap: _selecionarData,
                      validator: (_) => _data == null ? 'Informe a data' : null,
                    ),
                    AppPickerField(
                      label: 'Horário',
                      hint: 'Selecione o horário',
                      icon: Icons.schedule,
                      valueText: _horario == null
                          ? null
                          : _formatarHorario(_horario!),
                      onTap: _selecionarHorario,
                      validator: (_) =>
                          _horario == null ? 'Informe o horário' : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ------------------------------------------------------------
              // FORMATO
              // ------------------------------------------------------------
              FormSection(
                title: 'Formato',
                icon: Icons.movie_filter_outlined,
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChoiceChipGroup(
                      label: 'Idioma',
                      options: _idiomas,
                      selected: _idioma,
                      onSelected: (value) {
                        setState(() {
                          _idioma = value;
                        });
                      },
                    ),

                    ChoiceChipGroup(
                      label: 'Formato da exibição',
                      options: _formatos,
                      selected: _formato,
                      onSelected: (value) {
                        setState(() {
                          _formato = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ------------------------------------------------------------
              // PREÇO
              // ------------------------------------------------------------
              FormSection(
                title: 'Preço',
                icon: Icons.attach_money,
                child: AppTextField(
                  controller: _precoCtrl,
                  label: 'Preço do ingresso',
                  hint: 'Ex.: 35,00',
                  prefixIcon: Icons.payments_outlined,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    return _obrigatorio(value, 'Informe o preço');
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // --------------------------------------------------------------
      // AÇÕES
      // --------------------------------------------------------------
      bottomNavigationBar: FormActionBar(
        primaryLabel: 'Salvar sessão',
        primaryIcon: Icons.check,
        onPrimary: _salvar,
        secondaryLabel: 'Cancelar',
        onSecondary: () {
          Navigator.of(context).maybePop();
        },
      ),
    );
  }
}
