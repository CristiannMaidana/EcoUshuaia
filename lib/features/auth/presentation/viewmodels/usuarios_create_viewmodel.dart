import 'package:eco_ushuaia/core/domain/entities/usuario.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/usuario_repository.dart';
import 'package:flutter/foundation.dart';

class UsuariosCreateViewModel extends ChangeNotifier {
  final UsuariosRepository repo;
  
  UsuariosCreateViewModel(this.repo);

  bool _loading = false;
  String? _error;
  Usuario? _creado;

  bool get loading => _loading;
  String? get error => _error;
  Usuario? get creado => _creado;

  Future<void> crear({
    required String nombre,
    required String apellido,

    required String email,
    int? idDireccion,
    int? idZona,
    int? idTipoUsuario,
  }) async {
    _loading = true; _error = null; _creado = null; notifyListeners();
    try {
      final u = await repo.create(
        nombreUsuario: nombre,
        apellidoUsuario: apellido,
        email: email,
        idDireccion: idDireccion,
        idZona: idZona,
        idTipoUsuario: idTipoUsuario,
      );
      _creado = u;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }
}
