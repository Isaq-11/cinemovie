import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../utils/formatters.dart';
import '../../utils/validators.dart';
import '../../constants/app_options.dart';
import '../../models/filme.dart';
import '../../models/sala.dart';
import '../../models/sessao.dart';
import '../../router/app_routes.dart';
import '../../services/repositories.dart';

class SessionFormScreen extends StatefulWidget {
  const SessionFormScreen({super.key, this.id});

  final String? id;

  @override
  State<SessionFormScreen> createState() => _SessionFormScreenState();
}

class _SessionFormScreenState extends State<SessionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _precoCtrl = TextEditingController();

  List<Filme> _filmes = [];
  List<Sala> _salas = [];
  Filme? _filme;
  Sala? _sala;
  Sessao? _original;
  bool _carregandoDados = true;
  bool _salvando = false;

  String? _idioma = 'Dublado';
  String? _formato = '2D';

  DateTime? _data;
  TimeOfDay? _horario;

  static const Map<String, List<String>> _formatosPorSala = {
    '2D': ['2D'],
    '3D': ['2D', '3D'],
    'IMAX': ['2D', '3D', 'IMAX'],
    'VIP': ['2D', '3D'],
    'XD': ['2D', '3D'],
  };

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _precoCtrl.dispose();
    super.dispose();
  }

  List<String> get _formatosDisponiveis {
    if (_sala == null) return [];

    return _formatosPorSala[_sala!.tipo] ?? [];
  }

  bool _formatoCompativel() {
    if (_sala == null || _formato == null) return false;

    return _formatosDisponiveis.contains(_formato);
  }

  Future<void> _carregar() async {
    final original = widget.id == null
        ? null
        : await SessaoRepository.instance.getById(widget.id!);
    final filmes = await FilmeRepository.instance.getAll();
    final salas = (await SalaRepository.instance.getAll())
        .where((s) => s.ativa || s.id == original?.salaId)
        .toList();

    final salaSelecionada = salas
        .where((s) => s.id == original?.salaId)
        .firstOrNull;

    final formatoOriginal = original?.formato;

    final formatosPermitidos = salaSelecionada == null
        ? <String>[]
        : (_formatosPorSala[salaSelecionada.tipo] ?? []);

    final formatoSelecionado = formatosPermitidos.contains(formatoOriginal)
        ? formatoOriginal
        : (formatosPermitidos.isNotEmpty ? formatosPermitidos.first : null);

    if (!mounted) return;

    setState(() {
      _filmes = filmes;
      _salas = salas;
      _original = original;

      if (original != null) {
        _filme = filmes.where((f) => f.id == original.filmeId).firstOrNull;
        _sala = salas.where((s) => s.id == original.salaId).firstOrNull;
        _data = original.inicio;
        _horario = TimeOfDay.fromDateTime(original.inicio);
        _idioma = original.idioma;
        _formato = formatoSelecionado;
        _precoCtrl.text = original.preco
            .toStringAsFixed(2)
            .replaceAll('.', ',');
      }

      _carregandoDados = false;
    });
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

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_sala == null || _formato == null) {
      showAppSnackBar(
        context,
        'Selecione uma sala e um formato de exibição.',
        isError: true,
      );
      return;
    }

    if (!_formatoCompativel()) {
      showAppSnackBar(
        context,
        'O formato de exibição não é compatível com a sala selecionada.',
        isError: true,
      );
      return;
    }

    final d = _data!;
    final h = _horario!;

    setState(() => _salvando = true);
    try {
      await SessaoRepository.instance.save(
        Sessao(
          filmeId: _filme!.id,
          filme: _filme!.titulo,
          poster: _filme!.poster,
          salaId: _sala!.id,
          sala: _sala!.nome,
          capacidade: _sala!.capacidade,
          inicio: DateTime(d.year, d.month, d.day, h.hour, h.minute),
          formato: _formato ?? '2D',
          idioma: _idioma ?? 'Dublado',
          preco: double.parse(_precoCtrl.text.replaceAll(',', '.')),
          vendidos: _original?.vendidos ?? 0, // edição preserva a lotação
        ),
        id: widget.id,
      );
      if (!mounted) return;
      showAppSnackBar(context, 'Sessão salva!');
      context.pop();
    } catch (e) {
      debugPrint('Erro ao salvar sessão: $e');
      if (mounted)
        showAppSnackBar(
          context,
          'Erro ao salvar. Tente novamente.',
          isError: true,
        );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregandoDados) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_filmes.isEmpty || _salas.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nova sessão')),
        body: EmptyState(
          icon: Icons.info_outline,
          title: 'Faltam cadastros',
          message:
              'Cadastre ao menos um filme e uma sala ativa antes de criar sessões.',
          actionLabel: _filmes.isEmpty ? 'Cadastrar filme' : 'Cadastrar sala',
          onAction: () => context.push(
            _filmes.isEmpty ? AppRoutes.movieNew : AppRoutes.theaterNew,
          ),
        ),
      );
    }

    return FormScaffold(
      title: widget.id == null ? 'Nova sessão' : 'Editar sessão',
      formKey: _formKey,
      primaryLabel: 'Salvar sessão',
      primaryIcon: Icons.check,
      isLoading: _salvando,
      onPrimary: _salvar,
      children: [
        FormSection(
          title: 'Filme',
          icon: Icons.movie_outlined,
          child: Column(
            spacing: 16,
            children: [
              AppDropdownField<Filme>(
                label: 'Filme',
                prefixIcon: Icons.movie_outlined,
                items: _filmes,
                value: _filme,
                itemLabel: (f) => f.titulo,
                onChanged: (f) => setState(() => _filme = f),
                validator: (f) => f == null ? 'Selecione um filme' : null,
              ),
              if (_filme != null)
                Row(
                  children: [
                    PosterPreview(imageUrl: _filme!.poster, width: 60),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text('${_filme!.duracao} min • ${_filme!.genero}'),
                    ),
                  ],
                ),
            ],
          ),
        ),
        FormSection(
          title: 'Exibição',
          icon: Icons.theaters_outlined,
          child: Column(
            spacing: 16,
            children: [
              AppDropdownField<Sala>(
                label: 'Sala',
                prefixIcon: Icons.meeting_room_outlined,
                items: _salas,
                value: _sala,
                itemLabel: (s) =>
                    '${s.nome} • ${s.tipo} • ${s.capacidade} lugares',
                onChanged: (s) {
                  setState(() {
                    _sala = s;

                    final disponiveis = s == null
                        ? <String>[]
                        : (_formatosPorSala[s.tipo] ?? []);

                    if (!disponiveis.contains(_formato)) {
                      _formato = disponiveis.isNotEmpty
                          ? disponiveis.first
                          : null;
                    }
                  });
                },
                validator: (s) => s == null ? 'Selecione a sala' : null,
              ),
              Row(
                spacing: 16,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // erros de alturas diferentes
                children: [
                  Expanded(
                    child: AppPickerField(
                      label: 'Data',
                      hint: 'Selecione',
                      icon: Icons.calendar_today_outlined,
                      valueText: _data == null ? null : Formatters.data(_data!),
                      onTap: _selecionarData,
                      validator: (_) => _data == null ? 'Informe a data' : null,
                    ),
                  ),
                  Expanded(
                    child: AppPickerField(
                      label: 'Horário',
                      hint: 'Selecione',
                      icon: Icons.schedule,
                      valueText: _horario == null
                          ? null
                          : Formatters.horario(_horario!),
                      onTap: _selecionarHorario,
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
                wrapAlignment: WrapAlignment.center,
                label: 'Idioma',
                options: AppOptions.idiomas,
                selected: _idioma,
                onSelected: (v) => setState(() => _idioma = v),
              ),
              ChoiceChipGroup(
                wrapAlignment: WrapAlignment.center,
                label: 'Formato de exibição',
                options: _formatosDisponiveis,
                selected: _formato,
                onSelected: (v) => setState(() => _formato = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
