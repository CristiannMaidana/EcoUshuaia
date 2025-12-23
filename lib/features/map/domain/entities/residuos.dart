class Residuos {
  final int idResiduo;
  final String nombre;
  final String colorHex;
  final double? peso;
  final String? instruccionReciclado;
  final String? descripcion;
  final int idCategoriaResiduo;

  Residuos({
    required this.idResiduo,
    required this.nombre,
    required this.colorHex,
    this.peso,
    this.instruccionReciclado,
    this.descripcion,
    required this.idCategoriaResiduo,
  });
}