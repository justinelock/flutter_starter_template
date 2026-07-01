import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 基础存储服务 Provider
/// 
/// 逻辑说明：
/// 使用 Riverpod 管理持久化存储实例。此处采用了 [SharedPreferencesAsync]，
/// 它是官方推荐的用于非阻塞式读取配置项的现代异步接口。
final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(SharedPreferencesAsync()),
  name: 'storageServiceProvider',
);

/// 通用本地存储服务 (StorageService)
/// 
/// 该类是对 [SharedPreferences] 的轻量封装，用于存储非敏感的业务数据，
/// 如：应用配置、用户偏好设置（主题模式、语言）、或者临时的非加密标识。
/// 
/// 注意：对于 Token、密码等敏感数据，请务必使用 [SecureStorageService]。
class StorageService {
  /// 构造函数，注入异步偏好设置接口。
  const StorageService(this._prefs);

  final SharedPreferencesAsync _prefs;

  /// 读取字符串类型数据
  /// 
  /// 如果 Key 不存在，则返回 null。
  Future<String?> getString(String key) => _prefs.getString(key);

  /// 持久化字符串类型数据
  /// 
  /// 采用异步写入方式，确保不会阻塞主 UI 线程的后续逻辑。
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// 读取布尔类型数据
  /// 
  /// 常用于检查引导页是否已展示、功能开关状态等。
  Future<bool?> getBool(String key) => _prefs.getBool(key);

  /// 持久化布尔类型数据
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  /// 移除指定 Key 的数据
  /// 
  /// 逻辑说明：常用于用户登出时清理特定的本地状态。
  Future<void> remove(String key) => _prefs.remove(key);

  /// 清空所有已保存的数据
  /// 
  /// 警告：该操作不可逆，会抹除应用内所有通过此服务保存的配置。
  Future<void> clear() => _prefs.clear();
}
