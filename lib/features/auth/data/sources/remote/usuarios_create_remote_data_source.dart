import '../../../../../core/network/http_client.dart';
import '../../models/usuario_create_request_dto.dart';
import '../../models/usuario_dto.dart';

class UsuariosCreateRemoteDataSource {
  final ApiClient api;

  UsuariosCreateRemoteDataSource(this.api);

  Future<UsuarioDto> postUser(UsuarioCreateRequestDto dto) async {
    final data = await api.post('/usuarios/', body: dto.toJson(), requiresAuth: false);
    return UsuarioDto.fromJson(data as Map<String, dynamic>);
  }
}
