import 'package:eco_ushuaia/core/domain/entities/usuario.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/usuario_create_repository.dart';

import '../models/usuario_create_request_dto.dart';
import '../sources/remote/usuarios_create_remote_data_source.dart';

class UsuariosCreateRepositoryImp implements UsuariosCreateRepository {
  final UsuariosCreateRemoteDataSource remote;

  UsuariosCreateRepositoryImp(this.remote);

  @override
  Future<Usuario> create({
    required String nombreUsuario,
    required String apellidoUsuario,
    required String email,
    required String password,
    int? idDireccion,
    int? idZona,
    int? idTipoUsuario,
  }) async {
    final dto = UsuarioCreateRequestDto.fromCreate(
      nombre: nombreUsuario,
      apellido: apellidoUsuario,
      email: email,
      password: password,
      idDireccion: idDireccion,
      idZona: idZona,
      idTipoUsuario: idTipoUsuario,
    );
    final creado = await remote.postUser(dto);
    return creado.toEntity();
  }
}
