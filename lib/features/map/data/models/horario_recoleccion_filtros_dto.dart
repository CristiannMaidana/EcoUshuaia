import 'package:eco_ushuaia/features/map/domain/entities/horario_recoleccion_filtros.dart';

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

  factory HorarioRecoleccionFiltrosDto.fromJson(Map<String, dynamic> json) {
    return HorarioRecoleccionFiltrosDto(
      idCategoriaResiduos: json['id_categoria_residuo'] as int,
      horaInicio: json['hora_inicio'] as String?,
      diaSemana: json['dia_semana'] as int?,
      idZona: json['id_zona'] as int?,
    );
  }

  HorarioRecoleccionFiltros toEntity() => HorarioRecoleccionFiltros(
    idCategoriaResiduos: idCategoriaResiduos,
    horaInicio: horaInicio,
    diaSemana: diaSemana,
    idZona: idZona,
  );
}