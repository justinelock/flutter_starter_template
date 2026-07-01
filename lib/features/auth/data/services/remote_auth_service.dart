import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

/// 远程认证服务实现类 (RemoteAuthService)
/// 
/// 该类负责处理与后端服务器的认证相关通信，包括用户登录和注册。
/// 它实现了 [AuthService] 接口，确保业务层与具体的网络实现解耦。
class RemoteAuthService implements AuthService {
  /// 构造函数，注入 [ApiClient] 用于发起网络请求。
  const RemoteAuthService(this._apiClient);

  /// 网络客户端实例，用于处理底层的 HTTP 通信、拦截器等逻辑。
  final ApiClient _apiClient;

  /// 用户登录方法
  /// 
  /// 发送用户凭据（邮箱和密码）到后端接口 '/auth/login'。
  /// [email] 用户输入的邮箱。
  /// [password] 用户输入的密码。
  /// 
  /// 返回包含用户信息和 Token 的 [AuthResult] 对象。
  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // 调用 ApiClient 的 POST 方法发起登录请求。
    // 请求数据是一个包含 email 和 password 的 Map。
    final response = await _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    
    // 解析响应数据并将其转换为业务层可用的 AuthResult 对象。
    // 如果后端没有返回用户详情，我们使用输入的 email 作为回退值。
    return _parseAuthResult(response.data, fallbackEmail: email);
  }

  /// 用户注册方法
  /// 
  /// 将新用户信息发送到后端接口 '/auth/register'。
  /// [email] 用户邮箱。
  /// [password] 用户密码。
  /// [displayName] 用户显示的昵称，可选参数。
  /// 
  /// 逻辑包含一个自动登录重试机制，以兼容不同的后端响应策略。
  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // 发起注册请求，动态构建包含非空字段的请求体。
    final response = await _apiClient.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        // 仅当 displayName 有实际内容时才添加到请求体中。
        if (displayName != null && displayName.trim().isNotEmpty)
          'displayName': displayName.trim(),
      },
    );

    try {
      // 尝试解析注册成功的返回数据。
      return _parseAuthResult(response.data, fallbackEmail: email);
    } on AuthException {
      // 容错逻辑：
      // 部分后端设计在注册成功后不直接返回 Token，只返回成功状态。
      // 为了让前端逻辑保持一致（即注册后立即可用），我们在此处自动调用一次登录接口。
      return login(email: email, password: password);
    }
  }

  /// 内部响应解析方法
  /// 
  /// 该方法负责处理后端的多种响应格式（扁平化或包装类），并转换为强类型的业务对象。
  /// [json] 后端返回的原始动态数据。
  /// [fallbackEmail] 用于在返回数据缺失用户信息时填充的邮箱地址。
  AuthResult _parseAuthResult(
    dynamic json, {
    required String fallbackEmail,
  }) {
    // 首先校验数据是否为 JSON 对象格式。
    if (json is! Map) {
      throw const AuthException('认证响应无效：预期为 JSON 对象结构');
    }

    // 处理常见的后端包装格式：例如 { "code": 0, "data": { ... }, "msg": "..." }。
    // 如果存在 'code' 字段，我们根据约定的状态码（0 代表成功）来提取真正的 'data' 内容。
    if (json.containsKey('code')) {
      if (json['code'] != 0) {
        // 如果业务状态码不为 0，则抛出后端返回的错误信息或默认错误。
        throw AuthException(json['msg']?.toString() ?? '认证请求失败');
      }
      json = json['data'];
    }

    // 在解包或处理后，确保当前的 json 对象仍然是有效的 Map。
    if (json is! Map) {
      throw const AuthException('认证响应无效：业务数据区格式不正确');
    }

    // 将动态 Map 转换为强类型的 Map<String, dynamic> 供模型解析使用。
    final data = Map<String, dynamic>.from(json);
    
    // 解析用户信息逻辑：
    // 优先从 'user' 字段读取，如果后端返回的是扁平结构（Token 和用户信息在同一层），
    // 或者完全没有返回用户信息，则使用 fallbackEmail 构造一个基础的用户模型。
    final userJson = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'] as Map)
        : <String, dynamic>{'email': fallbackEmail};

    return AuthResult(
      // 使用 User 模型和 Token 模型分别解析数据。
      user: UserModel.fromJson(userJson, fallbackEmail: fallbackEmail),
      token: AuthTokenModel.fromJson(data),
    );
  }
}
