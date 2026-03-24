import 'package:eco_ushuaia/core/domain/entities/usuario.dart';
import 'package:eco_ushuaia/features/shell/data/sources/usuarios_remote_data_sources.dart';
import 'package:eco_ushuaia/features/shell/domain/repositories/usuario_repository.dart';

class UsuarioRepositoryImp implements UsuarioRepository {
  final UsuariosRemoteDataSources remote;

  UsuarioRepositoryImp(this.remote);

  @override
  Future<Usuario> getUser() async {
    final dto = await remote.getUser();
    return dto.toEntity();
  }

  @override
  Future<Usuario> updateUser({
    String? nombreUsuario,
    String? apellidoUsuario,
    String? email,
  }) async {
    final dto = await remote.updateUser(
      nombreUsuario: nombreUsuario,
      apellidoUsuario: apellidoUsuario,
      email: email,
    );
    return dto.toEntity();
  }
}
