import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/environment/env_provider.dart';
import '../../../../core/constants/app_storage_keys.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/mock_auth_service.dart';
import '../services/remote_auth_service.dart';

/// 认证服务选择器 Provider
/// 
/// 逻辑说明：
/// 根据 [EnvConfig.enableMock] 标志位，在运行时决定注入真实的远程服务还是本地 Mock 服务。
/// 这种设计允许 UI 开发在后端接口尚未就绪时直接开始，只需切换环境开关即可，无需改动任何业务逻辑。
final authServiceProvider = Provider<AuthService>((ref) {
  final env = ref.watch(envConfigProvider);
  final logger = ref.watch(appLoggerProvider);

  // 【Mock 切换点】：
  // 在调试模式下默认开启 Mock 以提升开发效率；生产模式强制使用 Remote 实现。
  if (env.enableMock) {
    logger.info('Auth service selected: mock');
    return MockAuthService();
  }

  logger.info('Auth service selected: remote ${env.baseUrl}');
  return RemoteAuthService(ref.watch(apiClientProvider));
}, name: 'authServiceProvider');

/// 认证仓库 Provider
/// 
/// 逻辑说明：
/// 采用依赖注入模式，将具体的认证服务和存储服务注入到仓库实现中。
/// 仓库层是业务逻辑与数据来源的唯一中转站。
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    service: ref.watch(authServiceProvider),
    storage: ref.watch(storageServiceProvider),
    secureStorage: ref.watch(secureStorageServiceProvider),
  ),
  name: 'authRepositoryProvider',
);

/// 认证仓库实现类 (AuthRepositoryImpl)
/// 
/// 该类实现了领域层的接口，负责协调网络请求 (Service) 和本地持久化 (Storage)。
/// 它确保了认证流程的原子性：例如登录成功后必须同时保存 Token。
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthService service,
    required StorageService storage,
    required SecureStorageService secureStorage,
  })  : _service = service,
        _storage = storage,
        _secureStorage = secureStorage;

  final AuthService _service;
  final StorageService _storage;
  final SecureStorageService _secureStorage;

  /// 恢复用户状态逻辑
  /// 
  /// 逻辑说明：
  /// 在应用冷启动时调用，检查本地是否存有有效的 Token 和用户标识。
  /// 仅当 Token 和基本信息（如 Email）同时存在时，才认为用户可能处于登录态。
  @override
  Future<User?> restoreUser() async {
    // 从安全存储中读取敏感 Token
    final token = await _secureStorage.read(AppStorageKeys.token);
    // 从常规存储中读取非敏感的用户信息（用于恢复内存模型）
    final email = await _storage.getString(AppStorageKeys.userEmail);
    
    // 如果任何一个关键信息缺失，则返回 null，由 Controller 重定向至登录页
    if (token == null || email == null) return null;
    
    // 构造基础 User 模型返回，应用后续会自动触发 Token 有效性验证
    return UserModel.fromEmail(email);
  }

  /// 登录逻辑封装
  /// 
  /// 逻辑说明：
  /// 1. 执行网络登录请求。
  /// 2. 成功后，调用私有方法 [_persistSession] 将会话信息持久化到磁盘。
  /// 3. 如果失败，通过 [ErrorMapper] 将底层异常转换为领域层的 [Failure]，方便 UI 展示。
  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final result = await _service.login(email: email, password: password);
      // 原子操作：登录成功必须持久化 Token
      await _persistSession(result);
      return result.user;
    } catch (error) {
      // 统一错误处理：屏蔽底层网络库细节，只抛出业务层能理解的异常
      throw RepositoryFailure(ErrorMapper.toFailure(error));
    }
  }

  /// 注册逻辑封装
  /// 
  /// 逻辑与登录类似，但通常包含更多的用户信息字段。
  @override
  Future<User> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final result = await _service.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      await _persistSession(result);
      return result.user;
    } catch (error) {
      throw RepositoryFailure(ErrorMapper.toFailure(error));
    }
  }

  /// 登出逻辑
  /// 
  /// 逻辑说明：
  /// 彻底清除本地存储中的所有认证相关信息，确保下一次启动时进入登录流程。
  @override
  Future<void> logout() async {
    // 同时清除安全存储和常规存储
    await _secureStorage.delete(AppStorageKeys.token);
    await _storage.remove(AppStorageKeys.userEmail);
  }

  /// 会话持久化私有逻辑
  /// 
  /// 逻辑说明：
  /// - 敏感数据（accessToken）：存入 [SecureStorage]，加密存储在 iOS Keychain 或 Android Keystore 中。
  /// - 普通数据（email）：存入 [SharedPreferences]，方便快速读取。
  Future<void> _persistSession(AuthResult result) async {
    await _secureStorage.write(
      AppStorageKeys.token,
      result.token.accessToken,
    );
    await _storage.setString(AppStorageKeys.userEmail, result.user.email);
  }
}

/// 仓库层专属异常
/// 
/// 逻辑说明：
/// 用于包装所有在数据层发生的错误，并附带经过 [ErrorMapper] 转换后的 UI 可读信息。
class RepositoryFailure implements Exception {
  const RepositoryFailure(this.failure);

  final Failure failure;
}
