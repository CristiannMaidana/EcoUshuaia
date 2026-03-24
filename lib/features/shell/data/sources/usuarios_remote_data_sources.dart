import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/shell/data/models/usuario_dto.dart';
import 'package:eco_ushuaia/features/shell/data/models/usuario_update_request_dto.dart';

class UsuariosRemoteDataSources {
  final ApiClient api;

  UsuariosRemoteDataSources(this.api);

  Future<UsuarioDto> getUser() async {
    final data = await api.get('/usuarios/me/');
    return UsuarioDto.fromJson(data as Map<String, dynamic>);
  }

  Future<UsuarioDto> updateUser({required String nombreUsuario, required String apellidoUsuario}) async {
    final dto = UsuarioUpdateRequestDto(
      nombreUsuario: nombreUsuario,
      apellidoUsuario: apellidoUsuario,
    );
    final data = await api.patch('/usuarios/me/', body: dto.toJson());

    if (data is Map<String, dynamic>) {
      return UsuarioDto.fromJson(data);
    }

    if (data is Map) {
      return UsuarioDto.fromJson(Map<String, dynamic>.from(data));
    }

    return getUser();
  }
}
