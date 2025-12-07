import 'package:eco_ushuaia/features/map/domain/entities/residuo_lite.dart';

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
  final int? idZona;
  final int? idCoordenada;
  final int? idMapa;
  final ResiduoLite? residuo;

  Contenedor({
    required this.idContenedor,
    this.nombreContenedor,
    this.colorContenedor,
    this.capacidadTotal, 
    this.fechaInstalacion, 
    this.ultimoVaciado, 
    this.descripcionUbicacion,
    this.idZona,
    this.idCoordenada,
    this.idMapa,
    this.residuo,
  });
}