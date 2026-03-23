import 'package:eco_ushuaia/features/auth/domain/repositories/auth_usuario_repository.dart';
import 'package:flutter/foundation.dart';

class AuthUsuarioViewModel extends ChangeNotifier {
  final AuthUsuarioRepository repo;

  AuthUsuarioViewModel(this.repo);

  bool _loading = false;
  String? _error;
  bool _isAuthenticated = false;

  bool get loading => _loading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login({required String email, required String password}) async {
    _loading = true;
    _error = null;
    _isAuthenticated = false;
    notifyListeners();

    try {
      await repo.authUser(username: email, password: password);
      _isAuthenticated = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
