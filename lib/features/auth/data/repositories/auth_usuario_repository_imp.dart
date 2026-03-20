import 'package:eco_ushuaia/core/domain/entities/usuario.dart';
import 'package:eco_ushuaia/features/auth/data/models/auth_usuario_dto.dart';
import 'package:eco_ushuaia/features/auth/data/sources/remote/auth_usuario_remote_data_sources.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/auth_usuario_repository.dart';

class AuthUsuarioRepositoryImp implements AuthUsuarioRepository {
  final AuthUsuarioRemoteDataSources remote;

  AuthUsuarioRepositoryImp(this.remote);

  @override
  Future<Usuario> authUser({required String email, required String password}) async {
    final dto = AuthUsuarioDto(email: email, password: password);
    final usuario = await remote.authUser(dto);
    return usuario.toEntity();
  }
}
