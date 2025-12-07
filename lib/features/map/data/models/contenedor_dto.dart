import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuo_lite.dart';
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
  final ResiduoLite? residuo;

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
    this.residuo,
  });

  factory ContenedorDto.fromGeoJsonFeature(Map<String, dynamic> features) {
    final props = features['properties'] as Map<String, dynamic>? ?? const {};
    final geom = features['geometry'] as Map<String, dynamic>? ?? const {};
    final coords = (geom['coordinates'] as List?) ?? const [null, null];

    return ContenedorDto(
      idContenedor: features['id'] as int,
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
    residuo: residuo,
  );
}