class UsuarioContenedorFavoritos {
  final int? idUsuarioRegistroContenedor;
  final String? notaUsuarioContenedor;
  final int idContenedor;
  final int idUsuario;

  const UsuarioContenedorFavoritos({
    this.idUsuarioRegistroContenedor,
    this.notaUsuarioContenedor,
    required this.idContenedor,
    required this.idUsuario,
  });
}
