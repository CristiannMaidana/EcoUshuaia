import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';

class ContenedorDto {
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

  ContenedorDto({
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

  factory ContenedorDto.fromJson(Map<String, dynamic> json) {
    return ContenedorDto(
      idContenedor: (json['id_contenedor']) as int,
      nombreContenedor: (json['nombre_contenedor']) as String?,
      colorContenedor: (json['color_contenedor']) as String?,
      capacidadTotal: (json['capacidad_total']) as double?,
      fechaInstalacion: (json['fecha_instalacion']) as DateTime?,
      ultimoVaciado: (json['ultimo_vaciado']) as DateTime?,
      descripcionUbicacion: (json['descripcion_ubicacion']) as String?,
      idZona: (json['id_zona']) as int?,
      idResiduo: (json['id_residuo']) as int?,
      idCoordenada: (json['id_coordenda']) as int?,
      idMapa: (json['id_mapa']) as int?,
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
    idZona: idZona,
    idResiduo: idResiduo,
    idCoordenada: idCoordenada,
    idMapa: idMapa,
  );
}