import '../../../../../core/network/http_client.dart';
import '../../models/usuario_dto.dart';

class UsuariosRemoteDataSource {
  final ApiClient api;
  
  UsuariosRemoteDataSource(this.api);

  Future<UsuarioDto> getUser(UsuarioDto dto) async {
    final data = await api.post('/usuarios/', body: dto.toJson());
    return UsuarioDto.fromJson(data as Map<String, dynamic>);
  }
}
