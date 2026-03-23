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

  Future<bool> restoreSession() async {
    final refreshToken = await secureStorage.readRefreshToken();
    final accessToken = await secureStorage.readAccessToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return accessToken != null && accessToken.isNotEmpty;
    }

    try {
      final data = await api.post('/token/refresh/', body: {'refresh': refreshToken}, requiresAuth: false);

      final json = data as Map<String, dynamic>;
      final newAccessToken = json['access'];
      final newRefreshToken = json['refresh'];

      if (newAccessToken is! String || newAccessToken.isEmpty) {
        throw const FormatException('La respuesta de refresh no contiene un access token valido.');
      }

      await secureStorage.saveAccessToken(newAccessToken);

      if (newRefreshToken is String && newRefreshToken.isNotEmpty) {
        await secureStorage.saveRefreshToken(newRefreshToken);
      }

      return true;
    } catch (_) {
      if (accessToken != null && accessToken.isNotEmpty) {
        return true;
      }
      await secureStorage.clear();
      return false;
    }
  }

  Future<void> logout() {
    return secureStorage.clear();
  }
}
