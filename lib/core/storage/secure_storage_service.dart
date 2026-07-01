import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全存储服务 Provider
/// 
/// 逻辑说明：
/// 使用 Riverpod 管理 [FlutterSecureStorage] 实例。
/// 该服务用于存储应用中的敏感信息，如用户的 AccessToken、RefreshToken 等。
final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageService(FlutterSecureStorage()),
  name: 'secureStorageServiceProvider',
);

/// 安全存储服务 (SecureStorageService)
/// 
/// 对 [FlutterSecureStorage] 的二次封装。
/// 在 Android 端通常使用 AES 加密，并存储在 KeyStore 中；
/// 在 iOS 端则利用 Keychain 进行存储。
/// 
/// 相比于普通的 [StorageService]，此服务在处理用户凭据时提供了更高的安全等级。
class SecureStorageService {
  /// 构造函数，注入安全存储插件实例。
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  /// 读取敏感数据
  /// 
  /// [key] 存储的键名。
  /// 返回加密存储的值，如果不存在则返回 null。
  Future<String?> read(String key) => _storage.read(key: key);

  /// 写入敏感数据
  /// 
  /// [key] 存储的键名。
  /// [value] 需要加密存储的字符串。
  /// 
  /// 逻辑说明：此操作会触发平台层的加密逻辑，因此为异步操作。
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  /// 删除敏感数据
  /// 
  /// [key] 需要移除的键名。
  /// 
  /// 场景：通常在用户注销或 Token 失效时调用，确保本地不再留存任何过期的凭据。
  Future<void> delete(String key) => _storage.delete(key: key);
}
