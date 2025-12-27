class HorarioRecoleccionFiltrosDto {
  final int idCategoriaResiduos;
  final String? horaInicio;
  final int? diaSemana;
  final int? idZona;

  HorarioRecoleccionFiltrosDto({
    required this.idCategoriaResiduos,
    this.horaInicio,
    this.diaSemana,
    this.idZona
  });

  factory HorarioRecoleccionFiltrosDto.fromJson(Map<String, dynamic> json){
    return HorarioRecoleccionFiltrosDto(
      idCategoriaResiduos: json['id_categoria_residuo'],
      horaInicio: json['hora_inicio']!,
      diaSemana: json['dia_semana']!,
      idZona: json['id_zona']!,
    );
  }
}