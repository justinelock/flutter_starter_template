import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';

class AuthResult {
  const AuthResult({required this.user, required this.token});

  final User user;
  final AuthToken token;
}

abstract interface class AuthService {
  Future<AuthResult> login({required String mobile, required String password});
  Future<AuthResult> register({
    required String username,
    required String password,
    required String realName,
    required String idCard,
    required String inviteCode,
  });
}
