import 'package:eco_ushuaia/features/map/domain/entities/categoria_residuos.dart';

class CategoriaResiduosDto {
  final int idCategoriaResiduos;
  final String categoria;
  final String colorHex;

  const CategoriaResiduosDto({
    required this.idCategoriaResiduos,
    required this.categoria,
    required this.colorHex
  });

  factory CategoriaResiduosDto.fromJson(Map<String, dynamic> json) {
    return CategoriaResiduosDto(
      idCategoriaResiduos: json['id_categoria_residuo'],
      categoria: json['categoria'],
      colorHex: json['color_hex']
    );
  }

  CategoriaResiduos toEntity() => CategoriaResiduos(
    idCategoriaResiduos: idCategoriaResiduos, 
    categoria: categoria, 
    colorHex: colorHex
  );
}