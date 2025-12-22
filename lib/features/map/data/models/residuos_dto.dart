import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';

class ResiduosDto {
  final int idResiduo;
  final String nombre;
  final String imagen;
  final double peso;
  final String instruccionReciclado;
  final String descripcion;
  final int idCategoriaResiduo;

  ResiduosDto({
    required this.idResiduo,
    required this.nombre,
    required this.imagen,
    required this.peso,
    required this.instruccionReciclado,
    required this.descripcion,
    required this.idCategoriaResiduo,}
  );

  factory ResiduosDto.fromJson(Map<String, dynamic> json){
    return ResiduosDto(
      idResiduo: json['id_residuo'], 
      nombre: json['nombre'], 
      imagen: json['imagen'], 
      peso: json['peso'], 
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