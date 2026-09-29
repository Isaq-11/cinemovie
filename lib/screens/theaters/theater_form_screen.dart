import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/validators.dart';
import '../../widgets/widgets.dart';
import '../../router/app_routes.dart';

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

  static const _tipos = ['2D', '3D', 'IMAX', 'VIP', 'XD'];

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _capacidadeCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    if (!_formKey.currentState!.validate()) return;
    // TODO: salvar sala
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Nova sala' : 'Editar sala'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FormSection(
                title: 'Identificação',
                icon: Icons.meeting_room_outlined,
                child: Column(
                  spacing: 16,
                  children: [
                    AppTextField(
                      controller: _nomeCtrl,
                      label: 'Nome da sala',
                      hint: 'Ex.: Sala 1',
                      prefixIcon: Icons.badge_outlined,
                      textInputAction: TextInputAction.next,
                      validator: Validators.obrigatorio(
                        'Informe o nome da sala',
                      ),
                    ),
                    AppDropdownField<String>(
                      label: 'Tipo de sala',
                      prefixIcon: Icons.theaters_outlined,
                      items: _tipos,
                      value: _tipo,
                      itemLabel: (t) => t,
                      onChanged: (v) => setState(() => _tipo = v),
                      validator: (v) => v == null ? 'Selecione o tipo' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FormSection(
                title: 'Capacidade',
                icon: Icons.event_seat_outlined,
                child: AppTextField(
                  controller: _capacidadeCtrl,
                  label: 'Quantidade de assentos',
                  prefixIcon: Icons.event_seat_outlined,
                  suffixText: 'assentos',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: Validators.inteiroPositivo,
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
          ),
        ),
      ),
      bottomNavigationBar: FormActionBar(
        primaryLabel: 'Salvar sala',
        primaryIcon: Icons.check,
        onPrimary: _salvar,
        secondaryLabel: 'Cancelar',
        onSecondary: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}
