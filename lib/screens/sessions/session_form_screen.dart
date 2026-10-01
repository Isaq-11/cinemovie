import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../utils/formatters.dart';
import '../../utils/validators.dart';
import '../../constants/app_options.dart';
import '../../mocks/mock_data.dart';

class SessionFormScreen extends StatefulWidget {
  const SessionFormScreen({super.key, this.id});

  final String? id;

  @override
  State<SessionFormScreen> createState() => _SessionFormScreenState();
}

class _SessionFormScreenState extends State<SessionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _precoCtrl = TextEditingController();

  FilmeMock? _filme;
  SalaMock? _sala;

  String? _idioma = 'Dublado';
  String? _formato = '2D';

  DateTime? _data;
  TimeOfDay? _horario;

  @override
  void dispose() {
    _precoCtrl.dispose();
    super.dispose();
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
            spacing: 16,
            children: [
              AppDropdownField<FilmeMock>(
                label: 'Filme',
                prefixIcon: Icons.movie_outlined,
                items: mockFilmes,
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
              AppDropdownField<SalaMock>(
                label: 'Sala',
                prefixIcon: Icons.meeting_room_outlined,
                items: mockSalas.where((s) => s.ativa).toList(),
                value: _sala,
                itemLabel: (s) => '${s.nome} • ${s.tipo}',
                onChanged: (s) => setState(() => _sala = s),
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
                label: 'Idioma',
                options: AppOptions.idiomas,
                selected: _idioma,
                onSelected: (v) => setState(() => _idioma = v),
              ),
              ChoiceChipGroup(
                label: 'Formato de exibição',
                options: AppOptions.formatos,
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
