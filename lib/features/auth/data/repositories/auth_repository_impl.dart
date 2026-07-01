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

  // debug 默认走 mock（见 EnvConfig.enableMock）；prod 走远程实现。
  if (env.enableMock) {
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
    required AuthService service,
    required StorageService storage,
    required SecureStorageService secureStorage,
  })  : _service = service,
        _storage = storage,
        _secureStorage = secureStorage;

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
  Future<User> login({required String email, required String password}) async {
    try {
      final result = await _service.login(email: email, password: password);
      await _persistSession(result);
      return result.user;
    } catch (error) {
      throw RepositoryFailure(ErrorMapper.toFailure(error));
    }
  }

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

  @override
  Future<void> logout() async {
    await _secureStorage.delete(AppStorageKeys.token);
    await _storage.remove(AppStorageKeys.userEmail);
  }

  Future<void> _persistSession(AuthResult result) async {
    await _secureStorage.write(
      AppStorageKeys.token,
      result.token.accessToken,
    );
    await _storage.setString(AppStorageKeys.userEmail, result.user.email);
  }
}

class RepositoryFailure implements Exception {
  const RepositoryFailure(this.failure);

  final Failure failure;
}
