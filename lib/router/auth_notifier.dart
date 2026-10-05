import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    _sub = AuthService.instance.userChanges.listen((_) => notifyListeners());
  }

  late final StreamSubscription _sub;

  bool get isLoggedIn => AuthService.instance.isLoggedIn;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
