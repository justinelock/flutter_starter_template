import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<User?> restoreUser();
  Future<User> login({required String mobile, required String password});
  Future<User> register({
    required String username,
    required String password,
    required String realName,
    required String idCard,
    required String inviteCode,
  });
  Future<void> logout();
}
