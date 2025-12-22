class ResiduosDto {
  final int idResiduo;
  final String nombre;
  final String? imagen;
  final double? peso;
  final String? instruccionReciclado;
  final String? descripcion;
  final int idCategoriaResiduo;

  ResiduosDto(
    this.idResiduo,
    this.nombre,
    this.imagen,
    this.peso,
    this.instruccionReciclado,
    this.descripcion,
    this.idCategoriaResiduo,
  );
}