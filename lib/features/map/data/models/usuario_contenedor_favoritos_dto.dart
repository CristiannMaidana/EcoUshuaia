import 'package:eco_ushuaia/features/map/domain/entities/usuario_contenedor_favoritos.dart';

class UsuarioContenedorFavoritosDto {
  final int? idUsuarioRegistroContenedor;
  final String? notaUsuarioContenedor;
  final int idContenedor;
  final int idUsuario;

  UsuarioContenedorFavoritosDto({
    this.idUsuarioRegistroContenedor,
    this.notaUsuarioContenedor,
    required this.idContenedor,
    required this.idUsuario,
  });


  factory UsuarioContenedorFavoritosDto.fromJson(Map<String, dynamic> json) {
    return UsuarioContenedorFavoritosDto(
      idUsuarioRegistroContenedor: json['id_usuario_registro_contenedor'],
      notaUsuarioContenedor: json['nota_usuario_contenedor'],
      idContenedor: json['id_contenedor'],
      idUsuario: json['id_usuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario_registro_contenedor': idUsuarioRegistroContenedor,
      'nota_usuario_contenedor': notaUsuarioContenedor,
      'id_contenedor': idContenedor,
      'id_usuario': idUsuario,
    };
  }

  UsuarioContenedorFavoritos toEntity() => UsuarioContenedorFavoritos(
    idUsuarioRegistroContenedor: idUsuarioRegistroContenedor,
    notaUsuarioContenedor: notaUsuarioContenedor,
    idContenedor: idContenedor,
    idUsuario: idUsuario,
  );

  factory UsuarioContenedorFavoritosDto.fromEntity(UsuarioContenedorFavoritos entity) {
    return UsuarioContenedorFavoritosDto(
      idUsuarioRegistroContenedor: entity.idUsuarioRegistroContenedor,
      notaUsuarioContenedor: entity.notaUsuarioContenedor,
      idContenedor: entity.idContenedor,
      idUsuario: entity.idUsuario,
    );
  }
}
