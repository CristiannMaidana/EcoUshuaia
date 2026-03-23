class AuthUsuarioDto {
  final String username;
  final String password;

  AuthUsuarioDto({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}
