import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';

class AuthResult {
  const AuthResult({required this.user, required this.token});

  final User user;
  final AuthToken token;
}

/// 认证服务契约：UI / Controller 不感知 mock 与 remote 的差异。
abstract interface class AuthService {
  Future<AuthResult> login({required String email, required String password});

  Future<AuthResult> register({
    required String email,
    required String password,
    String? displayName,
  });
}
