import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart' as domain_entities;

class Coordenada {
  final double latitud;
  final double longitud;

  Coordenada({
    required this.latitud,
    required this.longitud,
  });
}

class ContenedorDto {
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

  ContenedorDto({
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

  factory ContenedorDto.fromGeoJsonFeature(Map<String, dynamic> features) {
    final props = features['properties'] as Map<String, dynamic>? ?? const {};
    final geom = features['geometry'] as Map<String, dynamic>? ?? const {};
    final coords = (geom['coordinates'] as List?) ?? const [null, null];

    DateTime? _toDate(dynamic v) =>
      (v is String) ? DateTime.tryParse(v) : (v is DateTime) ? v : null;

    return ContenedorDto(
      idContenedor: features['id'] as int,
      nombreContenedor: props['nombre_contenedor'] as String?,
      colorContenedor: props['color_contenedor'] as String?,
      capacidadTotal: (props['capacidad_total'] as num?)?.toDouble(),
      fechaInstalacion: _toDate(props['fecha_instalacion']),
      ultimoVaciado: _toDate(props['ultimo_vaciado']),
      descripcionUbicacion: props['descripcion_ubicacion'] as String?,
      coordenada: (coords[1] != null && coords[0] != null)
          ? Coordenada(
              latitud: (coords[1] as num).toDouble(),
              longitud: (coords[0] as num).toDouble(),
            )
          : null,
      idZona: props['id_zona'] as int?,
      idMapa: props['id_mapa'] as int?,
      idResiduo: props['id_residuo'] as int?,
    );
  }

  Contenedor toEntity() => Contenedor(
    idContenedor: idContenedor,
    nombreContenedor: nombreContenedor,
    colorContenedor: colorContenedor,
    capacidadTotal: capacidadTotal,
    fechaInstalacion: fechaInstalacion,
    ultimoVaciado: ultimoVaciado,
    descripcionUbicacion: descripcionUbicacion,
    coordenada: coordenada != null
        ? domain_entities.Coordenada(
            latitud: coordenada!.latitud,
            longitud: coordenada!.longitud,
          )
        : null,
    idZona: idZona,
    idMapa: idMapa,
    idResiduo: idResiduo
  );
}