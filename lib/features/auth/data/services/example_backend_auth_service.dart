import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

/// 示例：对接「手机号 + 实名 + 证件号」类后端时的参考实现。
///
/// 默认 **不会** 被 [authServiceProvider] 选中；fork 后若你的 API 与此类似，
/// 可复制本文件并按 [docs/TEMPLATE_CHECKLIST.md] 接线，或把字段映射写进
/// [RemoteAuthService]。
class ExampleBackendAuthService implements AuthService {
  const ExampleBackendAuthService(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // 示例后端用 mobile 字段；模版 UI 仍收集 email，可按需改成独立登录页字段。
    final response = await _apiClient.post(
      '/auth/login',
      data: {'mobile': email, 'password': password},
    );

    final json = response.data;
    if (json is! Map || json['code'] != 0) {
      throw AuthException(
        json is Map
            ? json['msg']?.toString() ?? 'Login failed'
            : 'Login failed',
      );
    }

    final data = Map<String, dynamic>.from(json['data'] as Map);
    return AuthResult(
      user: UserModel.fromEmail(email),
      token: AuthTokenModel.fromJson(data),
    );
  }

  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      data: {
        'username': email,
        'password': password,
        'realName': displayName ?? email.split('@').first,
        'idCard': '000000000000000000',
        'inviteCode': '',
      },
    );

    final json = response.data;
    if (json is! Map || json['code'] != 0) {
      throw AuthException(
        json is Map
            ? json['msg']?.toString() ?? 'Register failed'
            : 'Register failed',
      );
    }

    return login(email: email, password: password);
  }
}
