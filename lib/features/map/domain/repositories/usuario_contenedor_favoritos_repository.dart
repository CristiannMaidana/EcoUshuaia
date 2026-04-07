import 'package:eco_ushuaia/features/map/domain/entities/usuario_contenedor_favoritos.dart';

abstract class UsuarioContenedorFavoritosRepository {
  Future<List<UsuarioContenedorFavoritos>> listByUsuario(int idUsuario);

  Future<UsuarioContenedorFavoritos> create({
    required int idUsuario,
    required int idContenedor,
    String? notaUsuarioContenedor,
  });

  Future<void> deleteById(int idUsuarioRegistroContenedor);
}
