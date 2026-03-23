abstract class AuthUsuarioRepository {
  Future<void> authUser({required String username, required String password});
}
