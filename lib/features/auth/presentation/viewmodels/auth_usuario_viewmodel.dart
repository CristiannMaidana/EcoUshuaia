import 'package:eco_ushuaia/core/domain/entities/usuario.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/auth_usuario_repository.dart';
import 'package:flutter/foundation.dart';

class AuthUsuarioViewModel extends ChangeNotifier {
  final AuthUsuarioRepository repo;

  AuthUsuarioViewModel(this.repo);

  bool _loading = false;
  String? _error;
  Usuario? _usuario;

  bool get loading => _loading;
  String? get error => _error;
  Usuario? get usuario => _usuario;

  Future<void> login({required String email, required String password}) async {
    _loading = true;
    _error = null;
    _usuario = null;
    notifyListeners();

    try {
      _usuario = await repo.authUser(email: email, password: password);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
