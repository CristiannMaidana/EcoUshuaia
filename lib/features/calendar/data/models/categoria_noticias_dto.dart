import 'package:eco_ushuaia/features/calendar/domain/entities/categoria_noticias.dart';

class CategoriaNoticiasDto {
  final int idCategoriaNoticias;
  final String categoria;
  final String colorHex;

  CategoriaNoticiasDto({
    required this.idCategoriaNoticias,
    required this.categoria,
    required this.colorHex,
  });

  factory CategoriaNoticiasDto.fromJson(Map<String, dynamic> json) {
    return CategoriaNoticiasDto(
      idCategoriaNoticias: json['id_categoria_noticias'],
      categoria: json['categoria'],
      colorHex: json['color_hex'],
    );
  }

  CategoriaNoticias toEntity() => CategoriaNoticias(
    idCategoriaNoticias: idCategoriaNoticias,
    categoria: categoria,
    colorHex: colorHex,
  );
}