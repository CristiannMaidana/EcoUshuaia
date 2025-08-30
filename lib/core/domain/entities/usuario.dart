class Usuario {
  final int idUsuario;
  final String nombreUsuario;
  final String apellidoUsuario;
  final String email;

  final int? idDireccion;
  final int? idZona;
  final int? idTipoUsuario;

  const Usuario({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.apellidoUsuario,
    required this.email,
    this.idDireccion,
    this.idZona,
    this.idTipoUsuario,
  });
}