class AuthUsuarioDto {
  final String email;
  final String password;

  AuthUsuarioDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}