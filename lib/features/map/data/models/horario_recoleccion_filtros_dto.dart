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
}