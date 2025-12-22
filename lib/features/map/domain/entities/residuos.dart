class Residuos {
  final int idResiduo;
  final String nombre;
  final String? imagen;
  final double? peso;
  final String? instruccionReciclado;
  final String? descripcion;
  final int idCategoriaResiduo;

  Residuos({
    required this.idResiduo,
    required this.nombre,
    required this.imagen,
    required this.peso,
    required this.instruccionReciclado,
    required this.descripcion,
    required this.idCategoriaResiduo,
  });
}