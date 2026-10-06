import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;

  Stream<User?> get userChanges => _auth.userChanges();
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<void> login(String email, String senha) => _run(
    () =>
        _auth.signInWithEmailAndPassword(email: email.trim(), password: senha),
  );

  Future<void> register({
    required String nome,
    required String cinema,
    required String email,
    required String senha,
  }) => _run(() async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
    await cred.user?.updateDisplayName(nome);
  });

  Future<void> resetPassword(String email) =>
      _run(() => _auth.sendPasswordResetEmail(email: email.trim()));

  Future<void> logout() => _auth.signOut();

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_traduzir(e.code));
    }
  }

  String _traduzir(String code) => switch (code) {
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' => 'E-mail ou senha incorretos.',
    'email-already-in-use' => 'Já existe uma conta com este e-mail.',
    'weak-password' => 'A senha é muito fraca. Use ao menos 6 caracteres.',
    'invalid-email' => 'E-mail inválido.',
    'user-disabled' => 'Esta conta foi desativada.',
    'too-many-requests' =>
      'Muitas tentativas. Aguarde um pouco e tente de novo.',
    'network-request-failed' => 'Sem conexão. Verifique sua internet.',
    _ => 'Não foi possível concluir. Tente novamente.',
  };
}
