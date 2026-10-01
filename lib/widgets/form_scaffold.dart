import 'package:cine_movie/widgets/form_action_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FormScaffold extends StatelessWidget {
  const FormScaffold({
    super.key,
    required this.title,
    required this.formKey,
    required this.children,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIcon,
    this.secondaryLabel = 'Cancelar',
    this.onSecondary,
    this.isLoading = false,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final IconData? primaryIcon;
  final String secondaryLabel;
  final VoidCallback? onSecondary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16),
            child: Column(spacing: 16, children: children),
          ),
        ),
      ),
      bottomNavigationBar: FormActionBar(
        primaryLabel: primaryLabel,
        onPrimary: onPrimary,
        primaryIcon: primaryIcon,
        secondaryLabel: secondaryLabel,
        onSecondary: onSecondary ?? () => context.pop(),
        isLoading: isLoading,
      ),
    );
  }
}
