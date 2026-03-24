class UsuarioUpdateRequestDto {
  final String? nombreUsuario;
  final String? apellidoUsuario;
  final String? email;

  const UsuarioUpdateRequestDto({
    this.nombreUsuario,
    this.apellidoUsuario,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'nombre_usuario': nombreUsuario,
      'apellido_usuario': apellidoUsuario,
      'email': email,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
