class Contenedor {
  final int idContenedor;
  final String? nombreContenedor;
  final String? colorContenedor;
  final double? capacidadTotal;
  final DateTime? fechaInstalacion;
  final DateTime? ultimoVaciado;
  final String? descripcionUbicacion;
  final int? idZona;
  final int? idResiduo;
  final int? idCoordenada;
  final int? idMapa;

  Contenedor({
    required this.idContenedor,
    this.nombreContenedor,
    this.colorContenedor,
    this.capacidadTotal, 
    this.fechaInstalacion, 
    this.ultimoVaciado, 
    this.descripcionUbicacion,
    this.idZona,
    this.idResiduo,
    this.idCoordenada,
    this.idMapa
  });
}