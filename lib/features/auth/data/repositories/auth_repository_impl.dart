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

final authServiceProvider = Provider<AuthService>((ref) {
  final env = ref.watch(envConfigProvider);
  final logger = ref.watch(appLoggerProvider);
  if (env.featureFlags.enableMockLogin) {
    // 只有显式开启 mock 登录时才使用本地服务，默认按文档真实 API 对接。
    logger.info('Auth service selected: mock');
    return MockAuthService();
  }
  logger.info('Auth service selected: remote ${env.baseUrl}');
  return RemoteAuthService(ref.watch(apiClientProvider));
}, name: 'authServiceProvider');

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    service: ref.watch(authServiceProvider),
    storage: ref.watch(storageServiceProvider),
    secureStorage: ref.watch(secureStorageServiceProvider),
  ),
  name: 'authRepositoryProvider',
);

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this._service,
    required this._storage,
    required this._secureStorage,
  });

  final AuthService _service;
  final StorageService _storage;
  final SecureStorageService _secureStorage;

  @override
  Future<User?> restoreUser() async {
    final token = await _secureStorage.read(AppStorageKeys.token);
    final email = await _storage.getString(AppStorageKeys.userEmail);
    if (token == null || email == null) return null;
    return UserModel.fromEmail(email);
  }

  @override
  Future<User> login({required String mobile, required String password}) async {
    try {
      // 步骤 1：Repository 不关心 mock/remote 细节，只按真实登录语义传递 mobile/password。
      final result = await _service.login(mobile: mobile, password: password);
      await _secureStorage.write(
        AppStorageKeys.token,
        result.token.accessToken,
      );
      await _storage.setString(AppStorageKeys.userEmail, result.user.email);
      return result.user;
    } catch (error) {
      throw RepositoryFailure(ErrorMapper.toFailure(error));
    }
  }

  @override
  Future<User> register({
    required String username,
    required String password,
    required String realName,
    required String idCard,
    required String inviteCode,
  }) async {
    try {
      // 步骤 1：注册参数严格对应真实 UserRegisterReq，避免页面字段和后端协议脱节。
      final result = await _service.register(
        username: username,
        password: password,
        realName: realName,
        idCard: idCard,
        inviteCode: inviteCode,
      );
      await _secureStorage.write(
        AppStorageKeys.token,
        result.token.accessToken,
      );
      await _storage.setString(AppStorageKeys.userEmail, result.user.email);
      return result.user;
    } catch (error) {
      throw RepositoryFailure(ErrorMapper.toFailure(error));
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(AppStorageKeys.token);
    await _storage.remove(AppStorageKeys.userEmail);
  }
}

class RepositoryFailure implements Exception {
  const RepositoryFailure(this.failure);

  final Failure failure;
}
