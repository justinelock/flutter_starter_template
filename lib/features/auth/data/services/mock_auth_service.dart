import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

/// 本地 Mock 认证：任意合法邮箱 + 至少 6 位密码即可通过，供 debug / 测试使用。
class MockAuthService implements AuthService {
  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _validate(email, password);
    return AuthResult(
      user: UserModel.fromEmail(email.trim()),
      token: const AuthTokenModel(
        accessToken: 'mock_access_token',
        expiresInSeconds: 43199900,
      ),
    );
  }

  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _validate(email, password);
    final normalizedEmail = email.trim();
    return AuthResult(
      user: UserModel(
        id: normalizedEmail.hashCode.abs().toString(),
        email: normalizedEmail,
        displayName: displayName?.trim().isNotEmpty == true
            ? displayName!.trim()
            : normalizedEmail.split('@').first,
      ),
      token: const AuthTokenModel(
        accessToken: 'mock_registered_token',
        expiresInSeconds: 43199900,
      ),
    );
  }

  void _validate(String email, String password) {
    final emailError = Validators.email(email);
    final passwordError = Validators.password(password);
    if (emailError != null || passwordError != null) {
      throw AuthException(emailError ?? passwordError ?? 'Invalid credentials');
    }
  }
}
