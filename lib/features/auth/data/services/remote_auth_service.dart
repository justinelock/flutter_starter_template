import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

/// 通用远程认证：默认对接 email/password REST，fork 后按后端契约调整路径与解析。
class RemoteAuthService implements AuthService {
  const RemoteAuthService(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return _parseAuthResult(response.data, fallbackEmail: email);
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
        'email': email,
        'password': password,
        if (displayName != null && displayName.trim().isNotEmpty)
          'displayName': displayName.trim(),
      },
    );

    try {
      return _parseAuthResult(response.data, fallbackEmail: email);
    } on AuthException {
      // 部分后端注册接口不返回 token，注册成功后复用登录换取会话。
      return login(email: email, password: password);
    }
  }

  AuthResult _parseAuthResult(
    dynamic json, {
    required String fallbackEmail,
  }) {
    if (json is! Map) {
      throw const AuthException('Invalid auth response');
    }

    // 兼容 { code, data, msg } 与扁平 JSON 两种常见后端格式。
    if (json.containsKey('code')) {
      if (json['code'] != 0) {
        throw AuthException(json['msg']?.toString() ?? 'Auth request failed');
      }
      json = json['data'];
    }

    if (json is! Map) {
      throw const AuthException('Invalid auth response');
    }

    final data = Map<String, dynamic>.from(json);
    final userJson = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'] as Map)
        : <String, dynamic>{'email': fallbackEmail};

    return AuthResult(
      user: UserModel.fromJson(userJson, fallbackEmail: fallbackEmail),
      token: AuthTokenModel.fromJson(data),
    );
  }
}
