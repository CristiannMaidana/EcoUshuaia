import 'package:eco_ushuaia/core/domain/entities/usuario.dart';

abstract class UsuariosCreateRepository {
  Future<Usuario> create({
    required String nombreUsuario,
    required String apellidoUsuario,
    required String email,
    required String password,
    int? idDireccion,
    int? idZona,
    int? idTipoUsuario,
  });
}
