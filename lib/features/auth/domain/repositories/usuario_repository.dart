import 'package:eco_ushuaia/core/domain/entities/usuario.dart';

abstract class UsuariosRepository {

  Future<Usuario> create({
    required String nombreUsuario,
    required String apellidoUsuario,
    required String email,
    
    int? idDireccion,
    int? idZona,
    int? idTipoUsuario,
  });
}
