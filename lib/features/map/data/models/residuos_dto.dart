import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';

class ResiduosDto {
  final int idResiduo;
  final String nombre;
  final String? imagen;
  final double? peso;
  final String? instruccionReciclado;
  final String? descripcion;
  final int idCategoriaResiduo;

  ResiduosDto({
    required this.idResiduo,
    required this.nombre,
    this.imagen,
    this.peso,
    this.instruccionReciclado,
    this.descripcion,
    required this.idCategoriaResiduo,}
  );

  factory ResiduosDto.fromJson(Map<String, dynamic> json){
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v.replaceAll(',', '.'));
      return null;
    }

    return ResiduosDto(
      idResiduo: json['id_residuo'], 
      nombre: json['nombre'], 
      imagen: json['imagen'], 
      peso: parseDouble(json['peso']),
      instruccionReciclado: json['instruccion_reciclado'], 
      descripcion: json['descripcion'], 
      idCategoriaResiduo: json['id_categoria_residuos'],
    );
  }

  Residuos toEntity() => Residuos(
    idResiduo: idResiduo,
    nombre: nombre,
    imagen: imagen,
    peso: peso,
    instruccionReciclado: instruccionReciclado,
    descripcion: descripcion,
    idCategoriaResiduo: idCategoriaResiduo,
  );
}