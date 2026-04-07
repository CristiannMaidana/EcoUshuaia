import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/map/data/models/usuario_contenedor_favoritos_dto.dart';

class UsuarioContenedorFavoritosRemoteDataSource {
  final ApiClient api;

  UsuarioContenedorFavoritosRemoteDataSource(this.api);

  Future<List<UsuarioContenedorFavoritosDto>> listByUsuario(int idUsuario) async {
    final data = await api.get('/usuarios_contenedores_favoritos/', query: {'id_usuario': idUsuario});

    List<dynamic> list;
    if (data is Map && data['results'] is List) {
      list = data['results'] as List;
    } else if (data is List) {
      list = data;
    } else {
      list = const [];
    }

    return list
        .whereType<Map>()
        .map(
          (e) => UsuarioContenedorFavoritosDto.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .where((e) => e.idUsuario == idUsuario)
        .toList(growable: false);
  }


  Future<UsuarioContenedorFavoritosDto> create({required int idUsuario, required int idContenedor, String? notaUsuarioContenedor}) async {
    final dto = UsuarioContenedorFavoritosDto(
      notaUsuarioContenedor: notaUsuarioContenedor,
      idContenedor: idContenedor,
      idUsuario: idUsuario,
    );

    final data = await api.post('/usuarios_contenedores_favoritos/', body: dto.toCreateJson());

    if (data is Map<String, dynamic>) {
      return UsuarioContenedorFavoritosDto.fromJson(data);
    }

    if (data is Map) {
      return UsuarioContenedorFavoritosDto.fromJson(Map<String, dynamic>.from(data));
    }

    final relaciones = await listByUsuario(idUsuario);
    return relaciones.firstWhere((e) => e.idContenedor == idContenedor);
  }

  Future<void> deleteById(int idUsuarioRegistroContenedor) async {
    await api.delete('/usuarios_contenedores_favoritos/$idUsuarioRegistroContenedor/');
  }
}
