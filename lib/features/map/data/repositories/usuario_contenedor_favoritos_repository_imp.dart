import 'package:eco_ushuaia/features/map/data/sources/remote/usuario_contenedor_favoritos_remote_data_source.dart';
import 'package:eco_ushuaia/features/map/domain/entities/usuario_contenedor_favoritos.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/usuario_contenedor_favoritos_repository.dart';

class UsuarioContenedorFavoritosRepositoryImp implements UsuarioContenedorFavoritosRepository {
  final UsuarioContenedorFavoritosRemoteDataSource remote;

  UsuarioContenedorFavoritosRepositoryImp(this.remote);

  @override
  Future<List<UsuarioContenedorFavoritos>> listByUsuario(int idUsuario) async {
    final dtos = await remote.listByUsuario(idUsuario);
    return dtos.map((e) => e.toEntity()).toList(growable: false);
  }

  @override
  Future<UsuarioContenedorFavoritos> create({
    required int idUsuario,
    required int idContenedor,
    String? notaUsuarioContenedor,
  }) async {
    final dto = await remote.create(
      idUsuario: idUsuario,
      idContenedor: idContenedor,
      notaUsuarioContenedor: notaUsuarioContenedor,
    );
    return dto.toEntity();
  }

  @override
  Future<void> deleteById(int idUsuarioRegistroContenedor) async {
    await remote.deleteById(idUsuarioRegistroContenedor);
  }
}
