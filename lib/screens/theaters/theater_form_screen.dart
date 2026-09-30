import 'package:cine_movie/constants/app_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/validators.dart';
import '../../widgets/widgets.dart';

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

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _capacidadeCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    // TODO (Firebase): salvar sala
    showAppSnackBar(context, 'Sala salva!');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: widget.id == null ? 'Nova sala' : 'Editar sala',
      formKey: _formKey,
      primaryLabel: 'Salvar sala',
      primaryIcon: Icons.check,
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
        const SizedBox(height: 16),
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
