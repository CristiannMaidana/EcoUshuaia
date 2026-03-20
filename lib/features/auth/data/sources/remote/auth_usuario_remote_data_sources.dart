import 'package:eco_ushuaia/features/auth/data/models/usuario_dto.dart';
import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/auth/data/models/auth_usuario_dto.dart';

class AuthUsuarioRemoteDataSources {
  final ApiClient api;

  AuthUsuarioRemoteDataSources(this.api);

  Future<UsuarioDto> authUser(AuthUsuarioDto dto) async {
    final data = await api.post('/autentificacion/login/', body: dto.toJson());
    return UsuarioDto.fromJson(data as Map<String, dynamic>);
  }
}