class HorarioRecoleccionFiltros {
  final int idCategoriaResiduos;
  final String? horaInicio;
  final int? diaSemana;
  final int? idZona;

  HorarioRecoleccionFiltros({
    required this.idCategoriaResiduos,
    this.horaInicio,
    this.diaSemana,
    this.idZona
  });
}