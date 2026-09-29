class Validators {
  static String? Function(String?) obrigatorio(String msg) =>
      (v) => (v == null || v.trim().isEmpty) ? msg : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'E-mail inválido';
  }

  static String? senha(String? v) {
    if (v == null || v.isEmpty) return 'Informe a senha';
    return v.length < 6 ? 'Mínimo de 6 caracteres' : null;
  }

  static String? inteiroPositivo(String? v) {
    final n = int.tryParse(v ?? '');
    return (n == null || n <= 0) ? 'Informe um número maior que zero' : null;
  }

  static String? preco(String? v) {
    final n = double.tryParse((v ?? '').replaceAll(',', '.'));
    return (n == null || n <= 0) ? 'Informe um preço válido' : null;
  }
}
