class UsuarioUpdateRequestDto {
  final String? nombreUsuario;
  final String? apellidoUsuario;
  final String? email;
  final String? currentPassword;
  final String? password;

  const UsuarioUpdateRequestDto({
    this.nombreUsuario,
    this.apellidoUsuario,
    this.email,
    this.currentPassword,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'nombre_usuario': nombreUsuario,
      'apellido_usuario': apellidoUsuario,
      'email': email,
      'current_password': currentPassword,
      'password': password,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
