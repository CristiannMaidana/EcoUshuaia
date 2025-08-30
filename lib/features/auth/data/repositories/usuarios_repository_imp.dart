import 'package:eco_ushuaia/core/domain/entities/usuario.dart';
import 'package:eco_ushuaia/features/auth/domain/repositories/usuario_repository.dart';

import '../sources/remote/usuarios_remote_data_source.dart';
import '../models/usuario_dto.dart';

class UsuariosRepositoryImp implements UsuariosRepository {
  final UsuariosRemoteDataSource remote;
  
  UsuariosRepositoryImp(this.remote);

  @override
  Future<Usuario> create({
    required String nombreUsuario,
    required String apellidoUsuario,
    required String email,

    int? idDireccion,
    int? idZona,
    int? idTipoUsuario,
  }) async {
    final dto = UsuarioDto.fromForm(
      nombre: nombreUsuario,
      apellido: apellidoUsuario,
      email: email,
      idDireccion: idDireccion,
      idZona: idZona,
      idTipoUsuario: idTipoUsuario,
    );
    final creado = await remote.getUser(dto);
    return creado.toEntity();
  }
}
