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
      idCategoriaResiduos: json['id_categoria_residuos'],
      categoria: json['categoria'],
      colorHex: json['color_hex']
    );
  }
}