import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuo_lite.dart';

class ContenedorDto {
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

  ContenedorDto({
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

  factory ContenedorDto.fromJson(Map<String, dynamic> json) {
    ResiduoLite? parseResiduo(dynamic r) {
      if (r is Map<String, dynamic>) {
        final id = r['id'] is int ? r['id'] as int : int.tryParse('${r['id']}');
        final nombre = (r['nombre'] ?? '').toString();
        final categoria = r['categoria'] as String?;
        if (id != null && nombre.isNotEmpty) {
          return ResiduoLite(id: id, nombre: nombre, categoria: categoria);
        }
      }
      return null;
    }

    return ContenedorDto(
      idContenedor: (json['id_contenedor']) as int,
      nombreContenedor: (json['nombre_contenedor']) as String?,
      colorContenedor: (json['color_contenedor']) as String?,
      capacidadTotal: (json['capacidad_total']) as double?,
      fechaInstalacion: (json['fecha_instalacion']) as DateTime?,
      ultimoVaciado: (json['ultimo_vaciado']) as DateTime?,
      descripcionUbicacion: (json['descripcion_ubicacion']) as String?,
      idZona: (json['id_zona']) as int?,
      idCoordenada: (json['id_coordenda']) as int?,
      idMapa: (json['id_mapa']) as int?,
      residuo: parseResiduo(json['residuo']),
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
    idCoordenada: idCoordenada,
    idMapa: idMapa,
    residuo: residuo,
  );
}