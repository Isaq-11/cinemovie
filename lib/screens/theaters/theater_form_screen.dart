import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/validators.dart';
import '../../models/sala.dart';
import '../../services/repositories.dart';
import '../../widgets/widgets.dart';
import '../../constants/app_options.dart';

class TheaterFormScreen extends StatefulWidget {
  const TheaterFormScreen({super.key, this.id});
  final String? id;

  @override
  State<TheaterFormScreen> createState() => _TheaterFormScreenState();
}

class _TheaterFormScreenState extends State<TheaterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _capacidadeCtrl = TextEditingController();

  String? _tipo;
  bool _acessivel = true;
  bool _ativa = true;

  bool _carregandoDados = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _carregandoDados = true;
      _carregar();
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _capacidadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final s = await SalaRepository.instance.getById(widget.id!);
    if (!mounted) return;
    if (s == null) {
      showAppSnackBar(context, 'Sala não encontrada.', isError: true);
      context.pop();
      return;
    }
    setState(() {
      _nomeCtrl.text = s.nome;
      _capacidadeCtrl.text = '${s.capacidade}';
      _tipo = s.tipo;
      _acessivel = s.acessivel;
      _ativa = s.ativa;
      _carregandoDados = false;
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      await SalaRepository.instance.save(
        Sala(
          nome: _nomeCtrl.text.trim(),
          tipo: _tipo!,
          capacidade: int.parse(_capacidadeCtrl.text),
          acessivel: _acessivel,
          ativa: _ativa,
        ),
        id: widget.id,
      );
      if (!mounted) return;
      showAppSnackBar(context, 'Sala salva!');
      context.pop();
    } catch (e) {
      debugPrint('Erro ao salvar sala: $e');
      if (mounted) showAppSnackBar(context, 'Erro ao salvar. Tente novamente.', isError: true);
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

    return FormScaffold(
      title: widget.id == null ? 'Nova sala' : 'Editar sala',
      formKey: _formKey,
      primaryLabel: 'Salvar sala',
      primaryIcon: Icons.check,
      isLoading: _salvando,
      onPrimary: _salvar,
      children: [
        FormSection(
          title: 'Informações da sala',
          icon: Icons.meeting_room_outlined,
          child: Column(
            spacing: 16,
            children: [
              AppTextField(
                controller: _nomeCtrl,
                label: 'Nome',
                hint: 'Ex.: Sala 1',
                prefixIcon: Icons.badge_outlined,
                textInputAction: TextInputAction.next,
                validator: Validators.obrigatorio('Informe o nome'),
              ),
              AppTextField(
                controller: _capacidadeCtrl,
                label: 'Capacidade',
                suffixText: 'assentos',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.event_seat_outlined,
                validator: Validators.inteiroPositivo,
              ),
              AppDropdownField<String>(
                label: 'Tipo de Sala',
                prefixIcon: Icons.theaters_outlined,
                items: AppOptions.tiposSala,
                value: _tipo,
                itemLabel: (t) => t,
                onChanged: (v) => setState(() => _tipo = v),
                validator: (v) => v == null ? 'Selecione o tipo da sala' : null,
              ),
            ],
          ),
        ),
        FormSection(
          title: 'Características',
          icon: Icons.tune,
          child: Column(
            children: [
              AppSwitchTile(
                icon: Icons.accessible,
                title: 'Sala acessível',
                subtitle: 'Espaço para cadeirantes e mobilidade reduzida',
                value: _acessivel,
                onChanged: (v) => setState(() => _acessivel = v),
              ),
              AppSwitchTile(
                icon: Icons.power_settings_new,
                title: 'Sala ativa',
                subtitle: 'Disponível para receber novas sessões',
                value: _ativa,
                onChanged: (v) => setState(() => _ativa = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
