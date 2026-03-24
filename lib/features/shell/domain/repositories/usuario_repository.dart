import 'package:eco_ushuaia/core/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario> getUser();

  Future<Usuario> updateUser({required String nombreUsuario, required String apellidoUsuario});
}
