import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class RemoteAuthService implements AuthService {
  const RemoteAuthService(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthResult> login({
    required String mobile,
    required String password,
  }) async {
    // 步骤 1：按真实接口 UserLoginReq 字段提交 mobile/password。
    final response = await _apiClient.post(
      '/auth/login',
      data: {'mobile': mobile, 'password': password},
    );

    // 步骤 2：接口约定 code=0 表示成功，其他情况交给统一错误体系处理。
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
      user: UserModel.fromEmail(mobile),
      token: AuthTokenModel.fromJson(data),
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
    // 步骤 1：按真实接口 UserRegisterReq 字段提交注册资料。
    final response = await _apiClient.post(
      '/auth/register',
      data: {
        'username': username,
        'password': password,
        'realName': realName,
        'idCard': idCard,
        'inviteCode': inviteCode,
      },
    );

    // 步骤 2：注册成功后复用登录接口换取 token，保持后续存储流程一致。
    final json = response.data;
    if (json is! Map || json['code'] != 0) {
      throw AuthException(
        json is Map
            ? json['msg']?.toString() ?? 'Register failed'
            : 'Register failed',
      );
    }
    return login(mobile: username, password: password);
  }
}
