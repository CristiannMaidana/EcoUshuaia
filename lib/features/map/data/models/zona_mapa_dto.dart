import 'package:eco_ushuaia/core/domain/entities/coordenada.dart';
import 'package:eco_ushuaia/features/map/domain/entities/zona_geometria.dart';
import 'package:eco_ushuaia/features/map/domain/entities/zona_mapa.dart';

class ZonaMapaDto {
  final int idZona;
  final String nombreZona;
  final String colorZona;
  final ZonaGeometria? coordenada;
  final int? idMapa;
  final int? idCalendario;

  const ZonaMapaDto({
    required this.idZona,
    required this.nombreZona,
    required this.colorZona,
    this.coordenada,
    this.idMapa,
    this.idCalendario,
  });

  factory ZonaMapaDto.fromJson(Map<String, dynamic> json) {
    return ZonaMapaDto(
      idZona: json['id_zona'] as int,
      nombreZona: json['nombre_zona'] as String? ?? '',
      colorZona: json['color_zona'] as String? ?? '',
      coordenada: _parseGeometria(json['coordenada']),
      idMapa: json['id_mapa'] as int?,
      idCalendario: json['id_calendario'] as int?,
    );
  }

  static ZonaGeometria? _parseGeometria(dynamic raw) {
    if (raw is! Map<String, dynamic>) return null;

    final coordinates = (raw['coordinates'] as List? ?? const [])
        .whereType<List>()
        .map(_parsePolygon)
        .where((polygon) => polygon.isNotEmpty)
        .toList(growable: false);

    return ZonaGeometria(
      type: raw['type'] as String? ?? 'MultiPolygon',
      coordinates: coordinates,
    );
  }

  static List<List<Coordenada>> _parsePolygon(List rawPolygon) {
    return rawPolygon
        .whereType<List>()
        .map(_parseRing)
        .where((ring) => ring.isNotEmpty)
        .toList(growable: false);
  }

  static List<Coordenada> _parseRing(List rawRing) {
    return rawRing
        .map(_parsePoint)
        .whereType<Coordenada>()
        .toList(growable: false);
  }

  static Coordenada? _parsePoint(dynamic rawPoint) {
    if (rawPoint is! List || rawPoint.length < 2) return null;

    final lon = rawPoint[0];
    final lat = rawPoint[1];
    if (lon is! num || lat is! num) return null;

    return Coordenada(latitud: lat.toDouble(), longitud: lon.toDouble());
  }

  ZonaMapa toEntity() => ZonaMapa(
    idZona: idZona,
    nombreZona: nombreZona,
    colorZona: colorZona,
    coordenada: coordenada == null
        ? null
        : ZonaGeometria(
            type: coordenada!.type,
            coordinates: coordenada!.coordinates
                .map(
                  (polygon) => polygon
                      .map(
                        (ring) => ring
                            .map(
                              (point) => Coordenada(
                                latitud: point.latitud,
                                longitud: point.longitud,
                              ),
                            )
                            .toList(growable: false),
                      )
                      .toList(growable: false),
                )
                .toList(growable: false),
          ),
    idMapa: idMapa,
    idCalendario: idCalendario,
  );
}
