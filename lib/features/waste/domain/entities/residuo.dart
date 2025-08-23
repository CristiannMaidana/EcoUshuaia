class Residuo {
  final int idResiduo;
  final String nombre;
  final String? imagen;
  final String? categoria;
  final double? peso; 
  final String? instruccionReciclado;
  final String? descripcion;

  const Residuo({
    required this.idResiduo,
    required this.nombre,
    this.imagen,
    this.categoria,
    this.peso,
    this.instruccionReciclado,
    this.descripcion,
  });
}