import 'package:eco_ushuaia/core/domain/entities/usuario.dart';
import 'package:eco_ushuaia/features/shell/domain/repositories/usuario_repository.dart';
import 'package:flutter/foundation.dart';

class UsuarioViewModel extends ChangeNotifier {
  final UsuarioRepository repo;

  UsuarioViewModel(this.repo);

  bool _loading = false;
  bool _loadedOnce = false;
  String? _error;
  Usuario? _usuario;

  bool get loading => _loading;
  bool get loadedOnce => _loadedOnce;
  String? get error => _error;
  Usuario? get usuario => _usuario;
  bool get hasUsuario => _usuario != null;

  Future<void> load({bool forceRefresh = false}) async {
    if (_loading) return;
    if (_loadedOnce && !forceRefresh) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await repo.getUser();
      _loadedOnce = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserName({required String nombreUsuario, required String apellidoUsuario}) async {
    final nombre = nombreUsuario.trim();
    final apellido = apellidoUsuario.trim();

    if (nombre.isEmpty || apellido.isEmpty) {
      throw ArgumentError('El nombre y el apellido son obligatorios');
    }

    final usuarioActual = _usuario;
    if (usuarioActual != null &&
        usuarioActual.nombreUsuario == nombre &&
        usuarioActual.apellidoUsuario == apellido) {
      return;
    }

    try {
      _error = null;
      _usuario = await repo.updateUser(nombreUsuario: nombre, apellidoUsuario: apellido);
      _loadedOnce = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clear() {
    _usuario = null;
    _error = null;
    _loadedOnce = false;
    notifyListeners();
  }
}
