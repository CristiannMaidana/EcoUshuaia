class UsuarioUpdateRequestDto {
  final String? nombreUsuario;
  final String? apellidoUsuario;

  const UsuarioUpdateRequestDto({
    this.nombreUsuario,
    this.apellidoUsuario,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'nombre_usuario': nombreUsuario,
      'apellido_usuario': apellidoUsuario,
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
