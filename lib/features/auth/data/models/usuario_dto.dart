import 'package:eco_ushuaia/core/domain/entities/usuario.dart';

class UsuarioDto {
  final int? idUsuario;
  final String nombreUsuario;
  final String apellidoUsuario;
  final String email;

  final int? idDireccion;
  final int? idZona;
  final int? idTipoUsuario;

  UsuarioDto({
    this.idUsuario,
    required this.nombreUsuario,
    required this.apellidoUsuario,
    required this.email,
    this.idDireccion,
    this.idZona,
    this.idTipoUsuario,
  });

  factory UsuarioDto.fromJson(Map<String, dynamic> json) {
    return UsuarioDto(
      idUsuario: json['id_usuario'] as int?,
      nombreUsuario: json['nombre_usuario'] as String,
      apellidoUsuario: json['apellido_usuario'] as String,
      email: json['email'] as String,
      idDireccion: json['id_direccion'] as int?,
      idZona: json['id_zona'] as int?,
      idTipoUsuario: json['id_tipo_usuario'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'nombre_usuario': nombreUsuario,
      'apellido_usuario': apellidoUsuario,
      'email': email,
      'id_direccion': idDireccion,
      'id_zona': idZona,
      'id_tipo_usuario': idTipoUsuario,
    };
    map.removeWhere((k, v) => v == null);
    return map;
  }

  Usuario toEntity() => Usuario(
        idUsuario: idUsuario ?? 0,
        nombreUsuario: nombreUsuario,
        apellidoUsuario: apellidoUsuario,
        email: email,
        idDireccion: idDireccion,
        idZona: idZona,
        idTipoUsuario: idTipoUsuario,
      );

  static UsuarioDto fromForm({
    required String nombre,
    required String apellido,
    required String email,
    
    int? idDireccion,
    int? idZona,
    int? idTipoUsuario,
  }) =>
      UsuarioDto(
        nombreUsuario: nombre,
        apellidoUsuario: apellido,
        email: email,
        idDireccion: idDireccion,
        idZona: idZona,
        idTipoUsuario: idTipoUsuario,
      );
}
