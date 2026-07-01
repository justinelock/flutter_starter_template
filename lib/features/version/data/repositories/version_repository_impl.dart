import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/environment/env_provider.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/providers/package_info_provider.dart';
import '../../../../shared/providers/platform_provider.dart';
import '../../domain/entities/version_info.dart';
import '../../domain/repositories/version_repository.dart';
import '../services/mock_version_service.dart';
import '../services/remote_version_service.dart';
import '../services/version_service.dart';

/// 版本服务提供者 Provider
/// 
/// 逻辑说明：
/// 类似于认证模块，版本检查也支持环境切换。
/// 在 Mock 模式下，可以根据 featureFlags 强制模拟强更流程，极大地方便了 QA 测试。
final versionServiceProvider = Provider<VersionService>((ref) {
  final env = ref.watch(envConfigProvider);
  final logger = ref.watch(appLoggerProvider);

  // 【Mock 切换逻辑】：
  // 如果开启 Mock，注入 MockVersionService。
  // 注意：此处透传了 enableForceUpdateMock，用于控制 Mock 数据是否返回“必须更新”。
  if (env.enableMock) {
    logger.info('Version service selected: mock');
    return MockVersionService(
      forceUpdate: env.featureFlags.enableForceUpdateMock,
    );
  }

  // 生产环境注入真实的远程服务。
  logger.info('Version service selected: remote ${env.versionCheckUrl}');
  return RemoteVersionService(
    apiClient: ref.watch(apiClientProvider),
    endpoint: env.versionCheckUrl,
  );
}, name: 'versionServiceProvider');

/// 版本仓库 Provider
final versionRepositoryProvider = Provider<VersionRepository>(
  (ref) => VersionRepositoryImpl(ref),
  name: 'versionRepositoryProvider',
);

/// 版本仓库实现类 (VersionRepositoryImpl)
/// 
/// 逻辑说明：
/// 它是版本检查业务的聚合点。主要职责是收集当前设备的本地信息（版本号、平台类型），
/// 并将其发送给具体的服务类进行比对。
class VersionRepositoryImpl implements VersionRepository {
  /// 构造函数，注入 Riverpod 的 [Ref] 以便在方法内部灵活获取各种 Provider。
  const VersionRepositoryImpl(this._ref);

  final Ref _ref;

  /// 检查最新版本
  /// 
  /// 逻辑流程：
  /// 1. 获取当前 App 的版本号和构建号（来自原生层 package_info）。
  /// 2. 获取当前运行平台名称（ios, android, web）。
  /// 3. 调用具体服务的 latest 方法获取结果。
  @override
  Future<VersionInfo> checkLatest() async {
    // 异步获取原生包信息
    final packageInfo = await _ref.read(packageInfoProvider.future);
    // 获取当前平台标识
    final platform = _ref.read(platformNameProvider);
    
    // 发起查询，传递本地上下文数据
    return _ref.read(versionServiceProvider).latest(
          currentVersion: packageInfo.version,
          buildNumber: packageInfo.buildNumber,
          platform: platform,
        );
  }
}
