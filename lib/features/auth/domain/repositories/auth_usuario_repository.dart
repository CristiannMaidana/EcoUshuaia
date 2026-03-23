abstract class AuthUsuarioRepository {
  Future<void> authUser({required String username, required String password});
  Future<bool> restoreSession();
  Future<void> logout();
}
