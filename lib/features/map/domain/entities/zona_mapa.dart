import 'package:eco_ushuaia/features/map/domain/entities/zona_geometria.dart';

class ZonaMapa {
  final int idZona;
  final String nombreZona;
  final String colorZona;
  final ZonaGeometria? coordenada;
  final int? idMapa;
  final int? idCalendario;

  const ZonaMapa({
    required this.idZona,
    required this.nombreZona,
    required this.colorZona,
    this.coordenada,
    this.idMapa,
    this.idCalendario,
  });
}
