import 'package:eco_ushuaia/core/domain/entities/usuario.dart';

abstract class AuthUsuarioRepository {
  Future<Usuario> authUser({required String email, required String password});
}
