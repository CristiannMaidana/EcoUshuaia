import 'package:eco_ushuaia/core/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario> getUser();
}
