import '../entities/user.dart';

/// 认证仓储契约：模版层只约定邮箱 + 密码，具体后端字段在 Service 实现中映射。
abstract interface class AuthRepository {
  Future<User?> restoreUser();

  Future<User> login({required String email, required String password});

  Future<User> register({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> logout();
}
