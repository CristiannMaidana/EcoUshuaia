class Coordenada {
  final double latitud;
  final double longitud;

  Coordenada({
    required this.latitud,
    required this.longitud,
  });
}

class Contenedor {
  final int idContenedor;
  final String? nombreContenedor;
  final String? colorContenedor;
  final double? capacidadTotal;
  final DateTime? fechaInstalacion;
  final DateTime? ultimoVaciado;
  final String? descripcionUbicacion;
  final Coordenada? coordenada;
  final int? idZona;
  final int? idMapa;
  final int? idResiduo;

  Contenedor({
    required this.idContenedor,
    this.nombreContenedor,
    this.colorContenedor,
    this.capacidadTotal, 
    this.fechaInstalacion, 
    this.ultimoVaciado, 
    this.descripcionUbicacion,
    this.coordenada,
    this.idZona,
    this.idMapa,
    this.idResiduo,
  });
}