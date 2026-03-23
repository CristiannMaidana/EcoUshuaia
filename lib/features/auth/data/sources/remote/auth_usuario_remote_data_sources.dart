import 'package:eco_ushuaia/core/network/http_client.dart';
import 'package:eco_ushuaia/features/auth/data/models/auth_usuario_dto.dart';
import 'package:eco_ushuaia/services/secure_storage/secure_storage_services.dart';

class AuthUsuarioRemoteDataSources {
  final ApiClient api;
  final SecureStorageServices secureStorage;

  AuthUsuarioRemoteDataSources(this.api, this.secureStorage);

  Future<void> authUser(AuthUsuarioDto dto) async {
    await secureStorage.clear();

    final data = await api.post('/token/', body: dto.toJson(), requiresAuth: false);
    
    final json = data as Map<String, dynamic>;

    final accessToken = json['access'];
    final refreshToken = json['refresh'];

    if (accessToken is! String || refreshToken is! String) {
      throw const FormatException('La respuesta de autenticacion no contiene tokens JWT validos.');
    }

    await secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
