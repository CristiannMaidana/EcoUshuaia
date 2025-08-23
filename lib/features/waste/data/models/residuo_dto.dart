import '../../domain/entities/residuo.dart';

class ResiduoDto {
  final int idResiduo;
  final String nombre;
  final String? imagen;
  final String? categoria;
  final double? peso;
  final String? instruccionReciclado;
  final String? descripcion;
  
  ResiduoDto({
    required this.idResiduo,
    required this.nombre,
    this.imagen,
    this.categoria,
    this.peso,
    this.instruccionReciclado,
    this.descripcion,
  });
  
  factory ResiduoDto.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v.replaceAll(',', '.'));
      return null;
    }
    
    return ResiduoDto(
      idResiduo: (json['id'] ?? json['id_residuo']) as int,
      nombre: json['nombre'] as String,
      imagen: json['imagen'] as String?,
      categoria: json['categoria'] as String?,
      peso: parseDouble(json['peso']),
      instruccionReciclado: json['instruccion_reciclado'] as String?,
      descripcion: json['descripcion'] as String?,
    );
  }

  Residuo toEntity() => Residuo(
    idResiduo: idResiduo,
    nombre: nombre,
    imagen: imagen,
    categoria: categoria,
    peso: peso,
    instruccionReciclado: instruccionReciclado,
    descripcion: descripcion,
  );
}