import '../../../../core/errors/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class MockAuthService implements AuthService {
  @override
  Future<AuthResult> login({
    required String mobile,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _validate(mobile, password);
    return AuthResult(
      user: UserModel.fromEmail(mobile),
      token: const AuthTokenModel(
        accessToken: 'mock_access_token',
        expiresInSeconds: 43199900,
      ),
    );
  }

  @override
  Future<AuthResult> register({
    required String username,
    required String password,
    required String realName,
    required String idCard,
    required String inviteCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _validate(username, password);
    return AuthResult(
      user: UserModel.fromEmail(username),
      token: const AuthTokenModel(
        accessToken: 'mock_registered_token',
        expiresInSeconds: 43199900,
      ),
    );
  }

  void _validate(String account, String password) {
    final emailError = account.trim().isEmpty ? 'Account is required' : null;
    final passwordError = Validators.password(password);
    if (emailError != null || passwordError != null) {
      throw AuthException(emailError ?? passwordError ?? 'Invalid credentials');
    }
  }
}
