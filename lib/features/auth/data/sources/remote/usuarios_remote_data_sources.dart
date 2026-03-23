import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/auth/data/models/usuario_dto.dart';

class UsuariosRemoteDataSources {
  final ApiClient api;

  UsuariosRemoteDataSources(this.api);

  Future<UsuarioDto> getUser() async {
    final data = await api.get('/usuarios/me/');
    return UsuarioDto.fromJson(data as Map<String, dynamic>);
  }
}
