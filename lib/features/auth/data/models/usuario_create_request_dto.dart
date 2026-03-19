class UsuarioCreateRequestDto {
  final String nombreUsuario;
  final String apellidoUsuario;
  final String email;
  final String password;
  final int? idDireccion;
  final int? idZona;
  final int? idTipoUsuario;

  UsuarioCreateRequestDto({
    required this.nombreUsuario,
    required this.apellidoUsuario,
    required this.email,
    required this.password,
    this.idDireccion,
    this.idZona,
    this.idTipoUsuario,
  });

  factory UsuarioCreateRequestDto.fromCreate({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    int? idDireccion,
    int? idZona,
    int? idTipoUsuario,
  }) {
    return UsuarioCreateRequestDto(
      nombreUsuario: nombre,
      apellidoUsuario: apellido,
      email: email,
      password: password,
      idDireccion: idDireccion,
      idZona: idZona,
      idTipoUsuario: idTipoUsuario,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'nombre_usuario': nombreUsuario,
      'apellido_usuario': apellidoUsuario,
      'email': email,
      'password': password,
      'id_direccion': idDireccion,
      'id_zona': idZona,
      'id_tipo_usuario': idTipoUsuario,
    };
    map.removeWhere((k, v) => v == null);
    return map;
  }
}
